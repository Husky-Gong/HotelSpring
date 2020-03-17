package com.zx.service.impl;

import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;
import com.zx.common.PageInfo;
import com.zx.common.Result;
import com.zx.domain.Room;
import com.zx.mapper.RoomMapper;
import com.zx.query.RoomQuery;
import com.zx.service.IRoomService;
import org.springframework.beans.factory.annotation.Autowired;

public class RoomServiceImpl implements IRoomService {
    @Autowired
    private RoomMapper roomMapper;

    @Override
    public Result queryPage(RoomQuery query) {
        Page<Room> data = PageHelper.startPage(query.getPage(), query.getLimit());
        roomMapper.selectList(query);
        PageInfo<Room> pageInfo = new PageInfo(data.getResult(), data.getTotal());
        return new Result(pageInfo);
    }
}
