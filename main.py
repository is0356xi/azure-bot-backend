import os
from dotenv import load_dotenv
from flask import Flask, request, jsonify
from flask_restful import Resource, Api
from flask_cors import CORS
from schemas import (
    ChatRequest,
    ChatResponse,
)
from modules.openai_client import chatcompletion

load_dotenv()

# アプリケーションの設定
app = Flask(__name__)
api = Api(app)
CORS(app)
app.secret_key = os.getenv("SESSION_KEY")

# APIリソースの定義
class Chat(Resource):
    def post(self):
        # リクエストボディからデータを取得
        req = request.get_json()

        # リクエストの形式を確認
        data = ChatRequest(**req)

        # OpenAIにリクエストを送信
        result = chatcompletion(data.message)
        
        # レスポンスを返却
        res = ChatResponse(message=result)
        return jsonify(res.dict())


# ルーティング設定
api.add_resource(Chat, "/api/chat")


if __name__ == "__main__":
    app.run(debug=True, host='0.0.0.0')
