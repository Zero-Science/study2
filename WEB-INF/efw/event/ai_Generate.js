var ai_Generate = {};
ai_Generate.name = "AI生成";
ai_Generate.paramsFormat = {
	"#opt_type2":null,
	"#opt_summary2":null,
	"#text_detailed2":null,
	"#opt_difficulty2":null,
	"#opt_category2":null,
	"#opt_aiopt2":null,
	"piclist" : null,
	"#opt": null,
};

ai_Generate.fire = function (params) {

	var ret = new Result();

	// セッションチェック
	if(sessionCheck(ret) == false){return ret}

	var type =params["#opt_type2"];
	var summary =params["#opt_summary2"];
	var detailed =params["#text_detailed2"];
	var difficulty =params["#opt_difficulty2"];
	var category =params["#opt_category2"];
	var aiopt =params["#opt_aiopt2"];
	var state = "作成中";
	var no = new Date().format("yyyyMMdd-HHmmss");
	var piclist = params["piclist"];
	var opt = params["#opt"];

	if(opt == "new"){
		// AI質問情報管理
		db.change(
			"AILSSUES",
			"insertAiAnswer",
			{
				no : no,
				type : type,
				summary : summary,
				detailed : detailed,
				category : category,
				difficulty : difficulty,
				aiopt : aiopt,
				state : state,
				shopid : getUserId()
			}
		);
		// AI質問情報管理_添付資料
		var folder = "doc" + "//" + no.substring(0,6);
		if(!file.exists(folder)){
			file.makeDir(folder);
		}

		var sub_folder = folder + "//" + no;
		if(!file.exists(sub_folder)){
			file.makeDir(sub_folder);
		}

		for(var i = 0;i < piclist.length;i ++){

			var picinfo = piclist[i];

			var content = picinfo[0];
			var fextension = picinfo[1];
			var content_tb500 = picinfo[2];
			var content_tb200 = picinfo[3];
			var content_tb50 = picinfo[4];
			var comment = picinfo[5];

			// DBへ登録
			db.change(
				"AILSSUES",
				"insertAiDocumentDetailInfo",
				{
					no : no,
					document_sub_no : i + 1,
					suffix : fextension,
					content : content,
					content_tb500 : content_tb500,
					content_tb200 : content_tb200,
					content_tb50 : content_tb50,
					comment : comment,
					userid : getUserId(),
				}
			);

			var filename = no + "_" + (i + 1) + "." + fextension;
			var file_byte = dataURLToByteArray(content);
			// file.writeAllBytes( sub_folder + "//" + filename, file_byte);  不确定路径，最后再打开

		}

		ret.eval("toJAVA( '" + no + "','" + aiopt + "', '" + category + "');");
		ret.eval("ai_Issues_Promptdialog.dialog('close');");

		ret.eval("searchList();");

	}



	// 画面へ結果を返す
	return ret;

};

function dataURLToByteArray(dataURL) {
	// 分离Data URL的头部和base64数据部分
	const base64Data = dataURL.split(',')[1];

	// 使用普通数组存储字节数据
	const byteArray = [];

	// 自定义base64解码
	const base64Chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
	let buffer = 0;
	let bitsLeft = 0;

	// 移除可能存在的填充字符和换行符
	const cleanBase64 = base64Data.replace(/[^A-Za-z0-9+/]/g, '');

	for (let i = 0; i < cleanBase64.length; i++) {
		const char = cleanBase64[i];
		if (char === '=') break; // 遇到填充字符停止

		const value = base64Chars.indexOf(char);
		if (value === -1) continue;

		buffer = (buffer << 6) | value;
		bitsLeft += 6;

		if (bitsLeft >= 8) {
			bitsLeft -= 8;
			byteArray.push((buffer >> bitsLeft) & 0xFF);
			buffer &= (1 << bitsLeft) - 1;
		}
	}

	return byteArray;
}
