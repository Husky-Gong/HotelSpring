<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Room List</title>

    <link rel="stylesheet" href="resources/layui/css/layui.css" />
</head>
<body>
<div>
    <div class="layui-form layui-form-pane">
        <div class="layui-inline">
            <label for="name" class="layui-form-label">Hotel Name</label>
            <div class="layui-input-inline">
                <input type="text" id="name" class="layui-input" name="name" placeholder="Hotel Name">
            </div>
        </div>
        <button class="layui-btn" type="button" id="searchBtn">Search</button>
    </div>

    <table id="dataTable" lay-filter="dataTableFilter"></table>

</div>

<script type="text/html" id="headerBtns">
    <div class="layui-btn-group">
        <button class="layui-btn layui-btn-sm" lay-event="add"><i class="layui-icon layui-icon-add-1"></i>Add</button>
    </div>
</script>
<!-- 行工具栏 -->
<script type="text/html" id="rowBtns">
    <button class="layui-btn layui-btn-sm layui-btn-danger" lay-event="del"><i class="layui-icon layui-icon-delete"></i>Delete</button>
</script>

<!-- _____________________ADD_____________________ -->



<script type="text/html" id="addTpl">
    <div style="width: 400px;margin: auto;margin-top: 20px;">
        <!-- form 容器已定义好 -->
        <form class="layui-form layui-form-pane" lay-filter="formFilter">

            <div class="layui-form-item">
                <label class="layui-form-label" >Hotel Name</label>
                <div class="layui-inline">
                    <select name="name">
                        <option value="">Hotel name</option>
                        <option value="Crown Towers Melbourne">Crown Towers Melbourne</option>
                        <option value="Fairmont Grand Del Mar">Fairmont Grand Del Mar</option>
                        <option value="41 Hotel 41">41 Hotel 41</option>
                    </select>
                </div>
            </div>


            <div class="layui-form-item">
                <label class="layui-form-label">Price</label>
                <div class="layui-input-inline">
                    <input name="price" class="layui-input"  />
                </div>
            </div>


            <div class="layui-form-item" >
                <label class="layui-form-label" >Room</label>
                <div class="layui-input-block">
                    <input type="radio" name="type" value="1" title="Standard room"/><br>
                    <input type="radio" name="type" value="2" title="Superior room"/><br>
                    <input type="radio" name="type" value="3" title="President suite"/>
                </div>
            </div>


            <div class="layui-form-item">
                <label class="layui-form-label">Information:</label>
                <div class="layui-input-block">
                    <textarea name="info" id="info" style="width:250px"></textarea>
                </div>
            </div>


            <button type="button" id="submitBtn" lay-submit lay-filter="submitBtnFilter" class="display:none"></button>
        </form>
    </div>

</script>

<!-- _____________________LIST_____________________ -->

<script src="resources/layui/layui.js"></script>
<script>
    layui.use(['form','jquery','table','layer'],function () {
        var form = layui.form;
        var $ = layui.jquery;
        var table = layui.table;
        var layer = layui.layer;

        var  t = table.render({
            id:"dataTableId",
            elem:"#dataTable",
            url:"room/page.do",
            toolbar:"#headerBtns",
            height:480,
            page:true,
            cols:[[
                {type:'checkbox'},
                {field:'id',title:'ID',width:'85'},
                {field:'hotelName',title:'Hotel Name',width:'250'},
                {field:'type',title:'Type',width:'200',templet:function(d){
                        if(d.type == 1){
                            return "<b>Standard</b>";
                        }else if(d.type == 2){
                            return "<b>Superior</b>";
                        }else if(d.type == 3){
                            return "<b>President Suite</b>";
                        }
                    }},
                {field:'price',title:'Price',width:'80'},
                {field:'hotelAddress',title:'Address',width:'150'},
                {field:'hotelTel',title:'Tel',width:'130'},
                {title:'operation',toolbar:'#rowBtns',fixed:'right',width:'120'}
            ]],
            response:{
                "statusCode":200
            },
            parseData:function(rs){
                if(rs.code == 200){
                    return {
                        "code":rs.code,
                        "msg":rs.mas,
                        "count":rs.data.count,
                        "data":rs.data.data
                    }
                }
            },
        });

        $("#searchBtn").click(function () {
            var name = $("#name").val();
            t.reload({
                where:{
                    name:name,
                    page:1
                }
            });
        });

        //=====头监听事件=====================================================================
        table.on('toolbar(dataTableFilter)',function(d){
            //获取具体的事件类型
            var event = d.event;
            if(event == "add"){
                //调用具体的添加方法
                add();
            }
        });



//-----具体添加方法------------
        function add(){
            layer.open({
                type:1,//html
                title:'Add hotel',
                content:$("#addTpl").html(),//弹层内容
                area:['400px','500px'],//宽高
                btn:['Submit','Cancel'],
                btnAlign:'c',//按钮居中
                btn1:function(index,layero){//点击确认时触发的方法
                    //点击确认时 提交form表单
                    $("#submitBtn").click();//使用js点击隐藏的提交按钮
                },
                success:function(layero,index){//当弹出层  弹出时 调用的函数
                    form.render();//重新渲染 表单元素
                    //为表单绑定提交监听事件
                    form.on("submit(submitBtnFilter)",function(d){
                        //获取表单数据
                        var param = d.field;
                        //使用ajax提交数据
                        $.post("hotel.do?service=add",param,function(rs){
                            //校验业务码
                            if(rs.code != 200){
                                //显示异常信息
                                layer.msg(rs.msg);
                                return false;
                            }
                            //关闭弹出层
                            layer.close(index);
                            //重载数据列表
                            $("#searchBtn").click();
                        });
                        //阻止表单的默认提交行为
                        return false;
                    });
                }
            });
        }
        //==行监听事件=============================================
        table.on("tool(dataTableFilter)",function(d){
            var event = d.event;
            var data = d.data;
            if(event == "del"){
                del(data);
            }
        });
        //--Delete-----------------------------
        function del(data){
            //使用二次确认
            layer.confirm("Confirm to delete",function(index){
                //将需要重置的用户ID 传给后台
                $.get("hotel.do?service=delete",{id:data.roomId},function(rs){
                    //校验业务码
                    if(rs.code != 200){
                        //显示异常信息
                        layer.msg(rs.msg);
                        return false;
                    }
                    layer.msg("重置成功");
                    //关闭弹出层
                    layer.close(index);
                    //重载数据列表
                    $("#searchBtn").click();
                });
            });
        }





    });


</script>
</body>
</html>
