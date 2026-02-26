<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="efw" uri="efw" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>AI質問</title>
    <efw:Client />
    <link rel="stylesheet" href="css/common.css" type="text/css" />
    <link href="favicon.ico" rel="icon" type="image/x-icon" />
    <script type="text/javascript" src="js/common.js"></script>
    <style>
        .c_detail_header {
            width: 95%;
            height: 51px;
        }
        .table_detail_header td{
            border: 1px solid black;
        }
        .table_detail_header th{
            font-size: 12px;
            font-weight: bold;
        }


        select {
            height: 30px;
        }

    </style>
    <script>

        $(document).ready(function() {

        });
        // 初期化
        function init() {
            Efw('ai_lssues_init');
        }
        //Ai问题初始化
        function aiPrompt(obj){
            if(obj == "type"){
                var type =  $("#opt_type2").val();
                Efw('ai_lssues_PromptInit',{type : type,summary : "" , obj : obj});
            } else if(obj == "summary"){
                var type =  $("#opt_type2").val();
                var summary = $("#opt_summary2").val();

                Efw('ai_lssues_PromptInit',{type : type , summary : summary , obj : obj});
            }else{

                Efw('ai_lssues_PromptInit',{type : '' , summary : '' , obj : obj});
                $("#text_detailed2").val("");
                $("#opt_summary2").empty();
                $("#opt_category2").val("");
                $(".pictr1").remove();
                $(".pictr3").remove();

                ai_Issues_Promptdialog.dialog('open');
            }
        }
        //检索按钮
        function searchList(){
            var type = getSelectedValue("opt_type");
            var difficulty = getSelectedValue("opt_difficulty");
            console.log(type)
            console.log(difficulty)
            Efw('ai_lssues_search',{type : type,difficulty : difficulty});
        }
        //获取select的值
        function getSelectedValue(selectId) {
            var selectElement = document.getElementById(selectId);
            var selectedIndex = selectElement.selectedIndex;
            var options = selectElement.options;
            var selectedOption = options[selectedIndex];
            return selectedOption.value;
        }
        //回答
        function aiAnswer(){

            var selectedValues =  $("input[name='testitem']:checked").val();

            const windowFeatures =
                "toolbar=no," +
                "location=no," +
                "directories=no," +
                "status=no," +
                "menubar=no," +
                "scrollbars=yes," +
                "resizable=yes," +
                "width=" + screen.availWidth + "," +
                "height=" + screen.availHeight;

            localStorage.setItem("selectedValues", JSON.stringify(selectedValues));
            window.open("ai_Issues_Promptpop.jsp", 'fullscreenWindow', windowFeatures);

        }

        function checkTest(){
            var selectedValues = [];
            $("input[name='testitem']:checked").each(function() {
                selectedValues.push($(this).val());
            });

            if(selectedValues.length == 0){
                $('#btn_aianswer').attr("disabled",true);
                $('#btn_delete').attr("disabled",true);
            }else if(selectedValues.length == 1){
                $('#btn_aianswer').attr("disabled",false);
                $('#btn_delete').attr("disabled",false);
            }else{
                $('#btn_aianswer').attr("disabled",true);
                $('#btn_delete').attr("disabled",false);
            }
        }

        // //    JAVA
        async function toJAVA(no,aiopt,category){

            var args = new Array();
            args[0] = aiopt;
            args[1] = no;
            args[2] = category;
            await   Efw('ai_Generate2',{args : args});
        }
        async function toJAVA2(no){
            await   Efw('ai_Generate3',{no : no});
        }
        //    删除
        function deleteTest(){
            var selectedValues = [];
            $("input[name='testitem']:checked").each(function() {
                selectedValues.push($(this).val());
            });
            Efw('ai_Delete',{selectedValues : selectedValues});
        }


        function changeColor(){

            $("#testwordtable .tr1").each(function () {

                var status = $(this).children().eq(3).children().eq(0).html();

                if(status == "回答済"){
                    $(this).css("background-color", "rgb(200,200,200)");
                }else if(status == "作成済"){
                    $(this).css("background-color", "rgb(200,255,255)");
                }

            });

        }

        //     关闭弹窗
        function close(){
            $("#opt").val("new")
            ai_Issues_Promptdialog.dialog('close');
        }

    </script>
</head>

<body onload="init();">
<efw:Part path="ai_Issues_Promptdialog.jsp" />
<div style="overflow: auto;">
    <div class="head">
        <div class="hleft">
            <h1 style="height: 80px;line-height: 80px;margin-left:40px;">STUDY</h1>
        </div>
        <div class="hright">
            <table style="float: right;width: 100%;color: aliceblue;">
                <tr>
                    <td>
                        <button class="hright_r"
                                onclick="Efw('common_menu_goto',{page:'common_login.jsp'})">ログオフ</button>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right;padding-right: 20px;" id="sessioninfo">
                        店舗ID：<span id="shopid" style="font-weight: bold;color: yellow;">未选择</span>
                        &nbsp;&nbsp;&nbsp;
                        UserID：<span id="userid" style="font-weight: bold;color: yellow;">XXXX</span>
                    </td>
                </tr>
            </table>
        </div>
    </div>
    <div class="topnav">
        <p><a href="common_menu.jsp">メニュー</a> > AI質問 </p>
    </div>
    <div class="content">
        <div class="c_btn">
            <table class="table_btn">
                <tbody>
                <tr>
                    <td style="width: 240px;">
                        類型:
                        <select id="opt_type" style="width: 160px;">
                            <option value=""  selected>All</option>
                        </select>
                    </td>
                    <td style="width: 240px;">
                        難易度:
                        <select id="opt_difficulty" style="width: 160px;"  >
                            <option value=""  selected>All</option>
                            <option value="１級">１級</option>
                            <option value="準１級">準１級</option>
                            <option value="２級">２級</option>
                            <option value="準２級">準２級</option>
                        </select>
                    </td>
                    <td></td>
                    <td style="text-align: right;color: red;font-weight: bold;vertical-align:middle;display: table-cell;"> </td>
                    <td style="width: 80px;"></td>
                    <td style="width: 80px;">
                        <button id="btn_testlist" onclick="searchList();" style="width: 60px;">検索</button>
                    </td>
                    <td style="width: 120px;">
                        <button id="btn_aigenerate" onclick="aiPrompt('')" style="width: 100px;">内容生成</button>
                    </td>
                    <td style="width: 80px;">
                        <button id="btn_aianswer" onclick="aiAnswer()" style="width: 60px;"  disabled>勉強</button>
                    </td>
                    <td style="width: 80px;">
                        <button id="btn_delete" onclick="deleteTest()" style="width: 60px;" disabled>削除</button>
                    </td>
                </tr>
                </tbody>
            </table>
        </div>

        <div class="c_detail_header" style="overflow: hidden;" >
            <table class="table_detail_header" style="table-layout: fixed;">
                <thead>
                <tr class="header">
                    <th style="width:  60px;" id="temp">選択</th>
                    <th style="width: 160px;">NO</th>
                    <th style="width: 200px;">類型</th>
                    <th style="width: 100px;">ステータス</th>
                    <th style="width: 100px;">難易度</th>
                    <th style="width: 300px;">プロンプト概要</th>
                    <th style="width: 450px;">プロンプト詳細</th>
                    <th style="width: 200px;">作成日時</th>
                    <th style="width: 200px;">回答時間</th>
                </tr>
                </thead>
            </table>
        </div>

        <div class="c_detail_content" style="overflow: auto;" onscroll="scrollHead(this);">
            <table class="table_detail_content" id="testwordtable" style="table-layout: fixed;text-align: center;">

            </table>
        </div>

    </div>
</div>

</body>
<script>
    $(document).ready(function() {

        // 获取屏幕宽度
        var screenWidth = window.screen.width;

        // 获取屏幕高度
        var screenHeight = window.screen.height;

        // 获取屏幕可用工作区宽度（不包括任务栏等）
        var screenAvailableWidth = window.screen.availWidth;

        // 获取屏幕可用工作区高度（不包括任务栏等）
        var screenAvailableHeight = window.screen.availHeight;

        var h0 = $(document).height();


        var h1 = $(".head").height();
        var h2 = $(".topnav").height();
        var h3 = $(".c_btn").height();
        var h4 = $(".c_condition").height();
        if(h4 == undefined){
            h4 = 0;
        }
        var h5 = $(".c_detail_header").height();

        var h6 = h0 - h1 - h2 - h3 - h4 - h5 - 30 -120;

        $(".c_detail_content").height(h6);

    });
</script>
</html>