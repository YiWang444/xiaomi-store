package com.example.shopping_system.service;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.example.shopping_system.dto.Result;
import com.example.shopping_system.mapper.OrdersMapper;
import com.example.shopping_system.mapper.ProductMapper;
import com.example.shopping_system.mapper.ShoppingCartMapper;
import com.example.shopping_system.pojo.Orders;
import com.example.shopping_system.pojo.ShoppingCart;
import com.example.shopping_system.util.SnowFlake;
import com.example.shopping_system.vo.OrderVo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class OrdersService {

    @Autowired
    private ShoppingCartMapper shoppingCartMapper;

    @Autowired
    private ProductMapper productMapper;

    @Autowired
    private OrdersMapper ordersMapper;

    @Transactional
    public boolean addOperator(int userID, List<Map<String, Object>> productsMapList) {
        try {
            long orderID = SnowFlake.nextId();
            // TODO: 减库存，保存订单,清理购物车
            for(Map<String, Object> productsMap : productsMapList) {
                // 保存订单
                int productID = (int)productsMap.get("productId");
                int price = (int)productsMap.get("price");
                int num = (int)productsMap.get("num");

                ordersMapper.insert(new Orders(orderID, userID, productID, num, price));

                // 清理购物车
                shoppingCartMapper.delete(new QueryWrapper<ShoppingCart>()
                        .eq("user_id", userID)
                        .eq("product_id", productID)
                );

                // 减库存(Redis优化)判断是否还有库存
                productMapper.updateById(productID, num);
            }

            return true;
        } catch (Exception e) {
            System.out.println(e);
            // TODO: 记录日志、发送告警、进行回滚等
            return false;
        }
    }

    public Result addOrder(int userID, List<Map<String, Object>> productsMapList) {

        return addOperator(userID, productsMapList) == true ?
                Result.success(null, "购买成功") :
                Result.error("002", "购买失败");
    }


    public Result getOrder(int userID) {
        ArrayList<List<OrderVo>> res = new ArrayList<>();
        List<OrderVo> orderList = ordersMapper.selectListJoinProduct(userID);

        if (orderList == null) {
            return Result.error("002", "该用户没有订单信息");
        }

        // 将同一个订单放在一组
        Map<String, List<OrderVo>> collect = orderList.stream().collect(Collectors.groupingBy(o -> o.getOrderId()));
        Collection<List<OrderVo>> mapValues = collect.values();
        res.addAll(mapValues);

        return Result.success(res, "查询订单成功");
    }
}
