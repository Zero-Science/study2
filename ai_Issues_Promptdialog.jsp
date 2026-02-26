<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<div class="dialog" id="ai_Issues_Promptdialog" style="display:block;background-color: rgb(255,255,240);">
    <script>
        var ai_Issues_Promptdialog = null;
        $(function () {
            ai_Issues_Promptdialog = $("#ai_Issues_Promptdialog").dialog({
                title: "AI生成",
                autoOpen: false,
                resizable: true,
                height: 1400,
                width: 1600,
                modal: true,
                open: function () {
                    setTimeout(function () { });
                },
                close: function () {
                    setTimeout(function () { });
                },
            });

        });


        // -------
        // 选择文件
        function openFileSelect(){
            $("#picfile").click();
        }
        // 获取上传文件
        function changepic(obj) {
            var filelist = $("#picfile")[0].files;
            handleFiles(filelist);
        }

        // 文件拖拽上传核心逻辑
        $(document).ready(function() {
            const dropZone = document.getElementById('dropZone');

            dropZone.addEventListener('dragover', (event) => {
                event.preventDefault();
                dropZone.classList.add('dragover');
            });

            dropZone.addEventListener('dragleave', () => {
                dropZone.classList.remove('dragover');
            });

            dropZone.addEventListener('drop', (event) => {
                event.preventDefault();
                dropZone.classList.remove('dragover');
                const files = event.dataTransfer.files;
                handleFiles(files);
            });

        });
        // 接收文件列表，解析文件信息，区分图片 / 普通文件并调用对应显示方法。
        function handleFiles(files) {
            for (let i = 0; i < files.length; i++) {
                let f = files[i];
                let fname = f.name;
                // 获取后缀
                let fextension = fname.substring(fname.lastIndexOf('.') + 1);
                if(validateFileType(fname)){

                    var reader = new FileReader();
                    reader.onload = function(e) {
                        if(isPic(fextension)){
                            // 画像表示
                            displayPic(e.target.result, fextension, fname);
                        }else{

                            displayFile(e.target.result, fextension, fname);

                        }
                    };
                    // 以 Base64 格式读取文件
                    reader.readAsDataURL(f);

                }
            }
        }
        // 是否包含指定图片格式
        // 还需添加
        function isPic(fextension){

            const imageExtensions = [ 'jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp', 'tiff',
                'ico', 'icns', 'sgi', 'jp2', 'heic', 'heif'];

            return imageExtensions.includes(fextension.toLowerCase());
        }
        /**
         * 验证文件类型是否允许上传
         * @param {string} filename - 文件名（例如 "photo.jpg"）
         * @returns {boolean} - 允许返回 true，否则弹窗并返回 false
         */
        function validateFileType(filename) {
            // 输入校验
            if (typeof filename !== 'string' || filename.trim() === '') {
                alert('文件名称："'+filename+'" 无效，请重新上传');
                return false;
            }

            // 提取扩展名（小写）
            const lastDotIndex = filename.lastIndexOf('.');
            if (lastDotIndex === -1 || lastDotIndex === filename.length - 1) {
                alert('文件格式："'+lastDotIndex+'" 不符合要求，请重新上传');
                return false;
            }
            const ext = filename.substring(lastDotIndex + 1).toLowerCase();

            // 允许的扩展名列表
            const allowedExtensions = [
                // 图片格式
                'jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp', 'tiff',
                'ico', 'icns', 'sgi', 'jp2', 'heic', 'heif',
                // 视频格式
                'mp4', 'avi', 'mov',
                // 文档格式
                'pdf', 'docx', 'txt', 'xls', 'xlsx'
            ];

            if (allowedExtensions.includes(ext)) {
                return true;
            } else {
                alert('上传文件："'+filename+'" 不符合要求，请重新上传');
                return false;
            }
        }

        // 显示普通文件（非图片）的预览：显示文件图标、操作按钮和备注输入框。
        function displayFile(content, fextension, comment){
            // Promise 异步
            return new Promise((resolve) => {

                var filecount = $(".upfile").length;
                var pictrcount = $(".pictr1").length;
                var position_r = Math.floor(filecount / 5);
                var position_c = filecount % 5;
                if(position_c == 0){
                    addTR();
                }
                addTD(content, null, null, fextension, comment);
                resolve();
            });

        }
        // 显示图片文件的预览：缩放图片、显示操作按钮和备注输入框。
        function displayPic(content, fextension, comment){

            return new Promise((resolve) => {

                var img = new Image();
                img.onload = function() {

                    var width = img.width;
                    var height = img.height;
                    // 统计上传文件的数量
                    var filecount = $(".upfile").length;
                    var position_r = Math.floor(filecount / 5);
                    var position_c = filecount % 5;
                    // 满5个添加一行
                    if(position_c == 0){
                        addTR();
                    }
                    addTD(content, width, height, fextension, comment);
                    // 返回一个状态为 resolved 的 Promise
                    resolve();
                };

                img.src = content;
            });

        }

        // 遍历每个pictd，当前td不为空则添加文件信息
        function addTD(content, width, height, fextension, comment){

            $(".pictd").each(function() {

                if($(this).html() == ""){

                    if(isPic(fextension)){

                        var imghtml = width >= height ? "width: 200px;" : "height: 200px;";
                        var html =
                            "<div class='image-container' style='height: 200px;width: 220px;'>" +
                            "<img src='" + content + "' class='upfile' style='" + imghtml + "'>" +
                            "<button class='delete-icon' onclick='deletePic(this);'><img src='img/delete2.png'></button>" +
                            "<button class='left-icon' onclick='movePicToLeft(this);'><img src='img/left2.png'></button>" +
                            "<button class='right-icon' onclick='movePicToRight(this);'><img src='img/right2.png'></button>" +
                            "<button class='rotate-icon' onclick='rotatePic(this);'><img src='img/kaiten.png'></button>" +
                            "<button class='open-icon' onclick='openPic(this);'><img src='img/open.png'></button>" +
                            "<input type='hidden' class='fextension' value='" + fextension.toLowerCase() +"'>" +
                            "</div>" +
                            "<textarea style='margin-top:" + "10px;' class='piccoment' rows='2'>" + comment + "</textarea>";
                    }else{
                        var html =
                            "<div class='image-container' style='height: 200px;width: 220px;'>" +
                            "<img src='img/" + fextension.toLowerCase() + ".png' class='upfile' style='width: 200px;height: 200px;'>" +
                            "<button class='delete-icon' onclick='deletePic(this);'><img src='img/delete2.png'></button>" +
                            "<button class='left-icon' onclick='movePicToLeft(this);'><img src='img/left2.png'></button>" +
                            "<button class='right-icon' onclick='movePicToRight(this);'><img src='img/right2.png'></button>" +
                            "<button class='open-icon' onclick='openFile(this);'><img src='img/open.png'></button>" +
                            "<input type='hidden' class='fextension' value='" + fextension.toLowerCase() +"'>" +
                            "<input type='hidden' class='filecontent' value='" + content +"'>" +
                            "</div>" +
                            "<textarea style='margin-top:" + "10px;' class='piccoment' rows='2'>" + comment + "</textarea>";

                    }
                    $(this).html(html);
                    return false;
                }

            });

        }
        //打开 / 下载普通文件（非图片）
        function openFile(obj){

            var filecontent = $(obj).parent().children().last().val();

            const link = document.createElement('a');
            link.href = filecontent;

            link.download = 'DownloadFile';

            link.click();

        }
        // 打开图片预览窗口（新窗口显示原图，支持进一步操作）
        function openPic(obj){

            var tdObj = $(obj).parent().parent();
            var rowIndex = tdObj.parent().index();
            var colIndex = tdObj.index();
            var fextension = $(obj).next().val();
            var comment = $(obj).parent().next().val();

            var imgObj = $(obj).parent().children().eq(0);
            var base64Image = imgObj.attr("src");

            const windowFeatures =
                "toolbar=no," +
                "location=no," +
                "directories=no," +
                "status=no," +
                "menubar=no," +
                "scrollbars=yes," +
                "resizable=yes," +
                "width=1920px," +
                "height=1080px";

            // "width=" + screen.availWidth + "," +
            // "height=" + screen.availHeight;

            const picw = window.open("document_pic2.jsp?row=" + rowIndex + "&col=" + colIndex + "&fextension=" + fextension + "&comment=" + comment, 'detailpic', windowFeatures);

            picw.onload = function(){
                picw.document.getElementById('picsrc').value = base64Image;

                picw.init();
            }

        }
        // 更新指定表格单元格中的图片内容（用于图片编辑后同步更新预览）
        function setPicContent(row, col, content){

            var table = $("#fileinfotable");
            var rowObj = table.find("tr").eq(row);
            var tdObj = rowObj.find("td").eq(col);
            tdObj.children().eq(0).children().eq(0).attr("src", content);

        }
        // 添加新行
        function addTR(){

            var html =
                "<tr style='height: 264px;width: 224px;' class='pictr1'>" +
                "<td style='width: 0px;'></td>" +
                "<td style='width: 220px;' class='pictd'></td>" +
                "<td style='width: 10px;'></td>" +
                "<td style='width: 220px;' class='pictd'></td>" +
                "<td style='width: 10px;'></td>" +
                "<td style='width: 220px;' class='pictd'></td>" +
                "<td style='width: 10px;'></td>" +
                "<td style='width: 220px;' class='pictd'></td>" +
                "<td style='width: 10px;'></td>" +
                "<td style='width: 220px;' class='pictd'></td>" +
                "</tr>" +
                "<tr style='height: 10px;' class='pictr3'>" +
                "<td colspan='7'></td>" +
                "</tr>";
            $("#fileinfotable").append(html);
        }
        // 获取所有图片与文件，保存
        function save(){

            var list = new Array();

            const promises = [];

            $(".image-container").each(function () {

                var fextension = $(this).find(".fextension").val();

                var pic = null;
                if(isPic(fextension)){
                    pic = $(this).find(".upfile").attr("src");
                }else{
                    pic = $(this).find(".filecontent").val();
                }


                var comment = $(this).next().val();

                var pic_tb500 = null;
                var pic_tb200 = null;
                var pic_tb50 = null;

                var data = new Array();

                data[0] = pic;
                data[1] = fextension;

                if(isPic(fextension)){

                    var image_tb500 = new Image();
                    var image_tb200 = new Image();
                    var image_tb50 = new Image();

                    const promise1 = new Promise((resolve) => {

                        image_tb500.onload = function() {
                            square = 500 / image_tb500.height;
                            canvas = document.createElement('canvas');
                            context = canvas.getContext('2d');
                            imageWidth = Math.round(square * image_tb500.width);
                            imageHeight = Math.round(square * image_tb500.height);
                            canvas.width = imageWidth;
                            canvas.height = imageHeight;
                            context.clearRect(0, 0, imageWidth, imageHeight);
                            context.drawImage(image_tb500, 0, 0, imageWidth, imageHeight);
                            pic_tb500 = canvas.toDataURL('image/jpeg', 1);

                            data[2] = pic_tb500;
                            resolve();
                        };
                    });
                    promises.push(promise1);

                    const promise2 = new Promise((resolve) => {

                        image_tb200.onload = function(){
                            square = 200 / image_tb200.height;
                            canvas = document.createElement('canvas');
                            context = canvas.getContext('2d');
                            imageWidth = Math.round(square * image_tb200.width);
                            imageHeight = Math.round(square * image_tb200.height);
                            canvas.width = imageWidth;
                            canvas.height = imageHeight;
                            context.clearRect(0, 0, imageWidth, imageHeight);
                            context.drawImage(image_tb200, 0, 0, imageWidth, imageHeight);
                            pic_tb200 = canvas.toDataURL('image/jpeg', 1);

                            data[3] = pic_tb200;
                            resolve();
                        };
                    });
                    promises.push(promise2);

                    const promise3 = new Promise((resolve) => {

                        image_tb50.onload = function(){
                            square = 50 / image_tb50.height;
                            canvas = document.createElement('canvas');
                            context = canvas.getContext('2d');
                            imageWidth = Math.round(square * image_tb50.width);
                            imageHeight = Math.round(square * image_tb50.height);
                            canvas.width = imageWidth;
                            canvas.height = imageHeight;
                            context.clearRect(0, 0, imageWidth, imageHeight);
                            context.drawImage(image_tb50, 0, 0, imageWidth, imageHeight);
                            pic_tb50 = canvas.toDataURL('image/jpeg', 1);

                            data[4] = pic_tb50;
                            resolve();
                        };
                    });
                    promises.push(promise3);

                    image_tb500.src = pic;
                    image_tb200.src = pic;
                    image_tb50.src = pic;

                }else{

                    const promise1 = new Promise((resolve) => {

                        data[2] = null;
                        resolve();

                    });
                    promises.push(promise1);

                    const promise2 = new Promise((resolve) => {

                        data[3] = null;
                        resolve();

                    });
                    promises.push(promise2);

                    const promise3 = new Promise((resolve) => {

                        data[4] = null;
                        resolve();

                    });
                    promises.push(promise3);
                }

                data[5] = comment;

                Promise.all(promises).then(() => {
                    list.push(data);
                });

            });
            Promise.all(promises).then(() => {
                console.log("listlength:" + list.length);

                // 逐个输出 list 中的元素
                list.forEach((item, index) => {
                    console.log(`list[${index}]:`, item);
                });

                Efw('ai_Generate',{piclist : list});
            });


        }
        // 旋转图片
        function rotatePic(obj){

            var imgObj = $(obj).parent().children().eq(0);
            var base64Image = imgObj.attr("src");

            var w = parseFloat(imgObj.css("width").replaceAll("px",""));
            var h = parseFloat(imgObj.css("height").replaceAll("px",""));

            rotateBase64Image(base64Image, -90).then(rotatedBase64Image => {
                if(w > h){
                    imgObj.css("height","200px");
                    imgObj.css("width","");
                }
                if(h > w){
                    imgObj.css("width","200px");
                    imgObj.css("height","");
                }

                imgObj.attr("src", rotatedBase64Image);
            });

        }
        // 将 Base64 格式的图片按指定角度旋转，返回旋转后的 Base64 内容
        function rotateBase64Image(base64Image, degrees) {

            return new Promise((resolve, reject) => {
                const canvas = document.createElement('canvas');
                const ctx = canvas.getContext('2d');
                const image = new Image();
                image.onload = function() {
                    const width = image.width;
                    const height = image.height;
                    canvas.width = height;
                    canvas.height = width;
                    ctx.translate(height / 2, width / 2);
                    ctx.rotate(degrees * Math.PI / 180);
                    ctx.drawImage(image, -width / 2, -height / 2);
                    resolve(canvas.toDataURL());
                };
                image.src = base64Image;
            });
        }
        // 将图片 / 文件向右移动到相邻的单元格（交换位置）
        function movePicToRight(obj){

            var picTdObj = $(obj).parent().parent();

            var nextTD = getNextPicTD(picTdObj);

            if(nextTD != null && nextTD !=undefined){

                var nhtml = nextTD.html();
                var html = $(picTdObj).html();

                if(nhtml != null && nhtml != ""){
                    nextTD.html(html);
                    $(picTdObj).html(nhtml);
                }

            }

        }
        // 将图片 / 文件向左移动到相邻的单元格（交换位置）
        function movePicToLeft(obj){

            var picTdObj = $(obj).parent().parent();

            var prevTD = getPrevPicTD(picTdObj);

            if(prevTD != null && prevTD !=undefined){

                var phtml = prevTD.html();
                var html = $(picTdObj).html();

                if(phtml != null && phtml != ""){
                    prevTD.html(html);
                    $(picTdObj).html(phtml);
                }

            }


        }
        // 删除当前文件 / 图片，并将后续的文件 / 图片向左移动填补空白
        function deletePic(obj){

            var tdObj = $(obj).parent().parent();
            tdObj.empty();

            var nextTD = getNextPicTD(tdObj);

            if(nextTD != null && nextTD != undefined && nextTD.html() != null && nextTD.html() != ""){

                movePicLeft(nextTD, true);
            }
            var filecount = $(".upfile").length;
            var pictrcount = $(".pictr1").length;

            if (pictrcount> 0 && filecount % 5 === 0) {
                $(".pictr1").last().remove();
            }

        }

        // 递归向左移动文件 / 图片
        function movePicLeft(obj, flg){

            //alert($(obj).html());

            var content = $(obj).html();

            // 前のTDに、内容を設定する
            var prevTD = getPrevPicTD(obj);

            if(prevTD != null && prevTD !=undefined){
                prevTD.append(content);
            }

            // このTDの内容をクリアする
            $(obj).empty();

            if(flg){
                var nextTD = getNextPicTD(obj);

                if(nextTD != null && nextTD != undefined && nextTD.html() != null && nextTD.html() != ""){
                    movePicLeft(nextTD, flg);
                }

            }
        }
        // 获取当前单元格的下一个有效的文件 / 图片单元格
        function getNextPicTD(obj){

            if($(obj).is(":last-child") == false){

                if($(obj).next().next() != null && $(obj).next().next() != undefined){

                    return $(obj).next().next();
                }else{

                    return null;
                }

            }else{

                var nextTR = $(obj).parent().next().next();
                if(nextTR != null && nextTR != undefined){

                    return nextTR.find("td:nth-child(2)");
                }else{

                    return null;
                }

            }

        }

        // 获取当前单元格的上一个有效的文件 / 图片单元格
        function getPrevPicTD(obj){

            if($(obj).is(":nth-child(2)") == false){

                if($(obj).prev().prev() != null && $(obj).prev().prev() != undefined){
                    return $(obj).prev().prev();
                }else{
                    return null;
                }

            }else{

                var prevTR = $(obj).parent().prev().prev();

                if(prevTR != null && prevTR != undefined){
                    return prevTR.find("td:last");
                }else{
                    return null;
                }

            }

        }
    </script>
    <style>

        #fileinfotable .pictd{
            border: 1px dashed  black;
        }

        .dragarea {
            font-size: 24px;
            text-align: center;
            font-weight: bold;
            color: gray;
            border-top: 1px dashed gray;
            border-bottom: 1px dashed gray;
            border-left: 1px dashed gray;
            border-right: 1px dashed gray;
        }
        .pictd {
            text-align: center;
            vertical-align: middle;
            border-top: 1px dashed gray;
            border-bottom: 1px dashed gray;
            border-left: 1px dashed gray;
            border-right: 1px dashed gray;
        }
        .image-container {
            /* position: relative;
            display: inline-block; */

            display: flex;
            align-items: center; /* 垂直居中 */
            justify-content: center; /* 水平居中 */

            position: relative;
        }
        .upfile {
            max-width: 100%; /* 确保图片不会超出容器 */
            max-height: 100%;
        }

        .delete-icon {

            position: absolute;
            top: 5px;
            right: 5px;
            border: none;
            padding: 5px;
            border-radius: 50%;
            cursor: pointer;
            font-size: 14px;

            /* position: absolute;
            top: 10px;
            right: 10px;
            background-color: red;
            color: white;
            border: none;
            border-radius: 50%;
            width: 20px;
            height: 20px;
            cursor: pointer; */

        }
        .left-icon {
            position: absolute;
            top: 40%;
            left: 0;
            border: none;
            padding: 5px;
            border-radius: 50%;
            cursor: pointer;
            font-size: 14px;
        }
        .right-icon {
            position: absolute;
            top: 40%;
            right: 0;
            border: none;
            padding: 5px;
            border-radius: 50%;
            cursor: pointer;
            font-size: 14px;
        }
        .rotate-icon {
            position: absolute;
            top: 15%;
            left: 40%;
            border: none;
            padding: 5px;
            border-radius: 50%;
            cursor: pointer;
            font-size: 14px;
        }
        .open-icon {
            position: absolute;
            top: 75%;
            left: 40%;
            border: none;
            padding: 5px;
            border-radius: 50%;
            cursor: pointer;
            font-size: 14px;
        }
        .delete-icon img,.left-icon img,.right-icon img,.rotate-icon img,.open-icon img {
            width: 20px;
            height: 20px;
        }

        .delete-icon:hover,.left-icon:hover,.right-icon:hover,.rotate-icon:hover,.open-icon:hover {
            background-color: gray;
        }

        .drop-zone {

            border: 1px dashed  black;
            height: 540px;
            width: 97%;
        }

        .drop-zone span {
            height: 100%;
            word-wrap: break-word;
            word-break: normal;
            display: flex;
            align-items: center;
            text-align: center;
            justify-content: center;
        }

        .piccoment {
            width: 100%;
            height: 50px;
        }


    </style>

    <div style="margin: 10px;">

        <table class="table_header1" id="aiprompttable" style="table-layout: fixed;text-align: left;border-bottom: 10px;width: 1495px;">
            <thead>
            <tr class="headers">
                <td style="width: 150px;">
                    類型:
                </td>
                <td style="width: 270px;">
                    <select id="opt_type2" style="width: 200px;height: 30px" onchange="aiPrompt('type');">
                        <option value="" selected hidden></option>
                    </select>
                </td>
                <td style="width: 150px;">
                    プロンプト概要:
                </td>
                <td style="width: 540px;" colspan="3">
                    <select id="opt_summary2" style="width: 682px;height: 30px" onchange="aiPrompt('summary');">
                        <option value="" selected ></option>
                    </select>
                </td>

            </tr>
            </thead>
            <tbody>
            <tr style="height: 200px;" class="copytr">
                <td style="width: 150px;"  >
                    プロンプト詳細:
                </td>
                <td style="width: 870px; height: 200px" colspan="5">
                    <textarea style="width: 1250px; height: 180px;text-align: left"  id="text_detailed2"></textarea>
                </td>
            </tr>

            <tr style="height: 40px;" class="copytr2">
                <td style="width: 150px;">
                    難易度:
                </td>
                <td style="width: 200px;">
                    <select id="opt_difficulty2" style="width: 200px;height: 30px">
                        <option value="１級">１級</option>
                        <option value="準１級">準１級</option>
                        <option value="２級" selected>２級</option>
                        <option value="準２級">準２級</option>
                    </select>
                </td>
                <td style="width: 150px;">
                    戻る値種類:
                </td>
                <td style="width: 200px;" >
                    <select id="opt_category2" style="width: 200px;height: 30px">
                        <option value="文章">文章</option>
                        <option value="HTML" selected>HTML</option>
                        <option value="JSON">JSON</option>
                    </select>
                </td>
                <td style="width: 150px;text-align: center">
                    AI選択:
                </td>
                <td style="width: 200px;" >
                    <select id="opt_aiopt2" style="width: 200px;height: 30px">
                        <option value="deepseek" selected>deepseek</option>
                        <option value="doubao">doubao</option>
                        <option value="gemini">gemini</option>
                        <option value="chatgpt">chatgpt</option>
                    </select>
                </td>
            </tr>

            </tbody>
        </table>
        <div style="width: 100%;height: 50px;line-height: 50px;"><b>添付ファイル</b></div>
        <div  style='width: 285px;height: 550px;display: inline-block;vertical-align: top'>

            <div class="drop-zone" id="dropZone" onclick="openFileSelect();"><span>ファイルをここにドラグしてください。</span></div>
            <input type="file" id="picfile" style="display: none;" onchange='changepic(this);' multiple>
        </div>
        <table border="0" id="fileinfotable" style="width: 1200px;height: 555px; display: inline-block;vertical-align: top;overflow: auto;">
            <tbody>
            <%--                <tr style='height: auto;'>--%>
            <%--                    <td style="width: 0px;"></td>--%>
            <%--                    <td style='width: 220px;height: 265px;' class="pictd"></td>--%>
            <%--                    <td style='width: 10px;'></td>--%>
            <%--                    <td style='width: 220px;' class="pictd"></td>--%>
            <%--                    <td style='width: 10px;'></td>--%>
            <%--                    <td style='width: 220px;' class="pictd"></td>--%>
            <%--                    <td style='width: 10px;'></td>--%>
            <%--                    <td style='width: 220px;' class="pictd"></td>--%>
            <%--                    <td style='width: 10px;'></td>--%>
            <%--                    <td style='width: 220px;' class="pictd"></td>--%>
            <%--                </tr>--%>
            <%--                <tr style="height: 10px"></tr>--%>
            <%--                <tr>--%>
            <%--                    <td style="width: 0px;"></td>--%>
            <%--                    <td style='width: 220px;height: 265px;' class="pictd"></td>--%>
            <%--                    <td style='width: 10px;'></td>--%>
            <%--                    <td style='width: 220px;' class="pictd"></td>--%>
            <%--                    <td style='width: 10px;'></td>--%>
            <%--                    <td style='width: 220px;' class="pictd"></td>--%>
            <%--                    <td style='width: 10px;'></td>--%>
            <%--                    <td style='width: 220px;' class="pictd"></td>--%>
            <%--                    <td style='width: 10px;'></td>--%>
            <%--                    <td style='width: 220px;' class="pictd"></td>--%>
            <%--                </tr>--%>
            </tbody>
        </table>
        <table class="table_inputdialog_btn" border="0">
            <tbody>
            <tr>

                <td style="width: 200px;"><button class="btn" id="btn_lottery" onclick="save();">AI生成</button></td>
                <%--                        <td style="width: 200px;"><button class="btn" id="btn_lottery" onclick="aiGenerate();">AI生成</button></td>--%>
                <td style="width: 200px;"><button class="btn" onclick="close()">キャンセル</button></td>
                <td style="width: 200px;">   <input type="hidden" value="new" id="opt"> </td>
            </tr>
            </tbody>
        </table>
    </div>
</div>