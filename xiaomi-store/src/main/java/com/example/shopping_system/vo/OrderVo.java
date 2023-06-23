package com.example.shopping_system.vo;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class OrderVo {
    private String orderId;

    private Integer userId;
    private Integer productId;
    private Integer productNum; // 买个几个
    private Integer productPrice;
    private LocalDateTime createTime; // 下单时间

    private String productName;
    private String productPicture;
}
