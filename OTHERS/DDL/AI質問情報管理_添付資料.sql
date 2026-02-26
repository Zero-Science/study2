
DROP TABLE IF EXISTS "public"."AI質問情報管理_添付資料";
CREATE TABLE "public"."AI質問情報管理_添付資料" (
  "番号" varchar(20) COLLATE "pg_catalog"."default" NOT NULL,
  "枝番号" int2 NOT NULL,
  "拡張子" varchar(10) COLLATE "pg_catalog"."default",
  "元ファイル" text COLLATE "pg_catalog"."default",
  "縮略ファイル500" text COLLATE "pg_catalog"."default",
  "縮略ファイル200" text COLLATE "pg_catalog"."default",
  "縮略ファイル50" text COLLATE "pg_catalog"."default",
  "コメント" varchar(255) COLLATE "pg_catalog"."default",
  "登録ID" varchar(20) COLLATE "pg_catalog"."default",
  "更新ID" varchar(20) COLLATE "pg_catalog"."default",
  "登録日時" timestamp(6),
  "更新日時" timestamp(6)
)
;

-- ----------------------------
-- Primary Key structure for table AI質問情報管理_添付資料
-- ----------------------------
ALTER TABLE "public"."AI質問情報管理_添付資料" ADD CONSTRAINT "AI質問情報管理_添付資料_pkey" PRIMARY KEY ("番号", "枝番号");
