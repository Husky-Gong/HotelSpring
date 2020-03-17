package com.zx.service;

import com.zx.common.Result;
import com.zx.query.RoomQuery;

public interface IRoomService {
    Result queryPage(RoomQuery query);
}
