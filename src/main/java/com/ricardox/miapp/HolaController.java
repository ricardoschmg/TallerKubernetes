package com.ricardox.miapp;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HolaController {

    @GetMapping("/saludo")
    public String saludar() {
        return "¡Hola, el microservicio está activo RS-GLO-CARO prueba";
    }

}
