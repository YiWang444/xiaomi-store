package com.example.shopping_system.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class OrdersDTO {
    private String orderId;
    private Integer userId;
    private Integer productId;
    private Integer productNum;
    private Double productPrice;
}
