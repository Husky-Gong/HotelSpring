package com.zx.controller;

import com.zx.common.Result;
import com.zx.query.RoomQuery;
import com.zx.service.IRoomService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("room")
public class RoomController {

    @Autowired
    private IRoomService roomService;

    @RequestMapping("page.do")
    @ResponseBody
    public Result queryPage(RoomQuery query){
        return roomService.queryPage(query);
    }
}
