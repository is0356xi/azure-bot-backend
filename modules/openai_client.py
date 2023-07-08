from langchain.chat_models import AzureChatOpenAI
from langchain.schema import (
    SystemMessage,
    HumanMessage,
    AIMessage,
)

import os
from dotenv import load_dotenv
load_dotenv()

MODEL_MAX_LENGTH = 300
MAX_TOKENS = 100

chat_histroy = []

def chatcompletion(userMessage:str) -> str:
    # LLMの初期化
    chat_llm = AzureChatOpenAI(
        openai_api_type="azure",
        deployment_name=os.getenv("AZURE_OPENAI_DEPLOYMENT_NAME"),
        openai_api_base=os.getenv("OPENAI_API_BASE"),
        openai_api_version=os.getenv("AZURE_OPENAI_API_VERSION"),
    )
   
    # メッセージを初期化
    messages = []

    # ユーザの入力トークン数を先に計算
    user_message = HumanMessage(content=userMessage)
    user_message_length = chat_llm.get_num_tokens_from_messages([user_message])

    # 履歴を反映 (新しい順に入れていく)
    if chat_histroy != []:
        chat_histroy.reverse()
        for chat in chat_histroy:
            messages.append(
                AIMessage(content=chat["ai"])
            )
            messages.append(
                HumanMessage(content=chat["user"])
            )

            # 履歴のトークン数を計算
            log_length = chat_llm.get_num_tokens_from_messages(messages)
            
            # 履歴のトークン数が最大トークン数を超えていたら、履歴を削除
            if log_length + user_message_length > MODEL_MAX_LENGTH - MAX_TOKENS:
                messages = messages[:-2] # 最も古い1ラリー分削除
                break
        
        # システムメッセージを末尾に追加
        messages.append(
            SystemMessage(content="あなたはユーザを助けるアシスタントです。")
        )

        # 古い順に戻す
        messages.reverse()
        print(messages)
    

    # ユーザの入力を追加
    messages.append(user_message)
    
    # 推論実行
    response = chat_llm(
        messages=messages,
        callbacks=[],
        max_tokens=MAX_TOKENS,
    )

    # 履歴に追加
    chat_histroy.append({"user": userMessage, "ai": response.content})
    

    return response.content
