package com.example.shopping_system.service;

import cn.hutool.core.bean.BeanUtil;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.example.shopping_system.dto.Result;
import com.example.shopping_system.dto.UserDTO;
import com.example.shopping_system.mapper.UserMapper;
import com.example.shopping_system.pojo.User;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Slf4j
@Service
public class UserService {

    @Autowired
    private UserMapper userMapper;

    public Result login(User u) {
        User user = userMapper.selectOne(new QueryWrapper<User>().eq("user_name", u.getUserName()));

        return user == null || !u.getPassword().equals(user.getPassword()) ?
                Result.error("004", "用户名或密码错误") :
                Result.success(BeanUtil.copyProperties(user, UserDTO.class), "登录成功");
    }

    public Result findUserName(String userName) {
        User user = userMapper.selectOne(new QueryWrapper<User>().eq("user_name", userName));

        return user != null ?
                Result.error("004", "用户名已经存在，不能注册") :
                Result.success(null, "用户名不存在，可以注册");
    }

    public Result register(User u) {
        User user = userMapper.selectOne(new QueryWrapper<User>().eq("user_name", u.getUserName()));

        if (user != null) {
            return Result.error("004", "用户名已经存在，不能注册");
        }

        userMapper.insert(u);
        return Result.success(null, "注册成功");
    }

    public Result getUserInfo(int userId) {
        return Result.success(BeanUtil.copyProperties(userMapper.selectOne(
                new QueryWrapper<User>().eq("user_id", userId)
        ), UserDTO.class), "查找用户成功");
    }

    public Result checkField(int userId, String field, String value) {
        User user = userMapper.selectById(userId);

        if(user == null) return Result.error("004", "用户不存在");

        if(field.equals("password")) {
            return user.getPassword().equals(value) ? Result.success() : Result.error("002", "旧密码错误，请重新输入");
        } else {
            // telephone
            if(user.getTelephone().equals(value)) {
                return Result.success(null, "检测通过");
            } else {
                return Result.error("003", "手机号码错误，不要更改默认选项");
            }
        }
    }

    public Result updateField(int userId, String field, String value) {
        User user = new User();
        user.setUserId(userId);

        if(field.equals("name")) {
            User user1 = userMapper.selectOne(new QueryWrapper<User>().eq("user_name", value));

            if(user1 == null) {
                user.setUserName(value);
            }else {
                return Result.error("002", "用户已存在，更改姓名失败");
            }

        } else if(field.equals("password")) {
            User user1 = userMapper.selectById(userId);

            if(!user1.getPassword().equals(value)) {
                user.setPassword(value);
            }else {
                return Result.error("003", "密码不能相同，更改密码失败");
            }
        } else {
            // telephone + 图片验证码 + Redis校验
            User user1 = userMapper.selectById(userId);

            if(!user1.getTelephone().equals(value)) {
                user.setTelephone(value);
            }else {
                return Result.error("004", "电话失败不能相同，更改电话号码失败");
            }
        }

        userMapper.updateById(user);
        return Result.success(null, "更改成功");
    }

    public Result saveUserImg(int userId, String fileName) {
        if(userMapper.selectById(userId) == null) return Result.error("004", "用户不存在");

        User user = new User();
        user.setUserId(userId);

        user.setUserImg("你的阿里云OSS前缀.aliyuncs.com/".concat(fileName));

        userMapper.updateById(user);
        return Result.success("你的阿里云OSS前缀.aliyuncs.com/".concat(fileName), "更新用户头像成功");
    }
}
