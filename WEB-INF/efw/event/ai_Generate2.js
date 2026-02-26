var ai_Generate2 = {};
ai_Generate2.name = "AI生成";
ai_Generate2.paramsFormat = {
	"args":null,
};

ai_Generate2.fire = function (params) {

	var ret = new Result();

	// セッションチェック
	if(sessionCheck(ret) == false){return ret};

	var args = params["args"];
	var no = args[0];
	excuteJar("OptTask06",args);

	ret.eval(" toJAVA2( '"+no+"');")
	// 画面へ結果を返す
	return ret;

};