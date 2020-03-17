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
    <div style="width: 400px; margin: 20px auto auto;">
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
            elem:"#dataTable",
            url:"room/page.do",
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

    });


</script>
</body>
</html>
