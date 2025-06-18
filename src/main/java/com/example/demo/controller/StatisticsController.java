package com.example.demo.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/usr/member")
public class StatisticsController {

    @GetMapping("/statistics")
    public String showStatisticsPage() {
        return "usr/member/statistics";
    }
    
}
