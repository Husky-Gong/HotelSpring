package com.zx.common;

import java.util.List;

public class PageInfo<T> {

    private List<T> data;

    private Long  count;

    public PageInfo(List<T> data, Long count) {
        this.data = data;
        this.count = count;
    }

    public List<T> getData() {
        return data;
    }

    public void setData(List<T> data) {
        this.data = data;
    }

    public Long getCount() {
        return count;
    }

    public void setCount(Long count) {
        this.count = count;
    }
}

