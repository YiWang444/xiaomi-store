package com.example.shopping_system.service;

import cn.hutool.core.bean.BeanUtil;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.example.shopping_system.dto.PageDTO;
import com.example.shopping_system.dto.ProductDTO;
import com.example.shopping_system.dto.Result;
import com.example.shopping_system.mapper.CategoryMapper;
import com.example.shopping_system.mapper.ProductMapper;
import com.example.shopping_system.mapper.ProductPictureMapper;
import com.example.shopping_system.pojo.ProductPicture;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ProductService {

    private static final int PAGE_SIZE = 7; // 首页展示同一类别前7(1-7)个商品

    @Autowired
    private ProductMapper productMapper;

    @Autowired
    private ProductPictureMapper productPictureMapper;

    @Autowired
    private CategoryMapper categoryMapper;

    public Result getPromoProduct(Integer categoryID) {

        return Result.success(productMapper.selectListOfDTO(categoryID, 0, PAGE_SIZE), "查询成功");
    }

    public Result getDetails(Integer productID) {

        return Result.success(BeanUtil.copyProperties(productMapper.selectById(productID), ProductDTO.class), "查询成功");
    }


    public Result getDetailsPicture(Integer productID) {
        return Result.success(productPictureMapper.selectList(new QueryWrapper<ProductPicture>().eq("product_id", productID)), "查询成功");
    }

    public Result getCategory() {

        return Result.success(categoryMapper.selectListByDTO(), "查询成功");
    }

    public Result getAllProduct(Integer categoryID, Integer pageSize, Integer currentPage) {

        Integer offset = (currentPage - 1) * pageSize;

        if (categoryID == null) {
            return Result.success(
                    new PageDTO(productMapper.selectAllListOfDTO(offset, pageSize)
                            , productMapper.selectAllTotalOfDTO())
                    , "查询成功");
        }else {
            return Result.success(
                    new PageDTO(productMapper.selectListOfDTO(categoryID, offset, pageSize)
                            , productMapper.selectCountOfDTO(categoryID))
                    , "查询成功");
        }
    }

    public Result getHotProduct(Integer categoryID) {

        return Result.success(productMapper.selectListByHotProduct(categoryID, 0, PAGE_SIZE), "查询成功");
    }

    public Result getProductBySearch(String keyWord, Integer pageSize, Integer currentPage) {
        Integer offset = (currentPage - 1) * pageSize;

        return Result.success(new PageDTO(
                productMapper.selectListProductBySearch(keyWord, offset, pageSize),
                productMapper.selectTotalProductBySearch(keyWord)
        ), "查询成功");
    }
}
