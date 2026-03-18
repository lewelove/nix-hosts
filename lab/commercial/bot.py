import os
import asyncio
from telegram import Update
from telegram.ext import ApplicationBuilder, CommandHandler, ContextTypes, MessageHandler, filters

async def start(update: Update, context: ContextTypes.DEFAULT_TYPE):
    user = update.effective_user.first_name
    await update.message.reply_text(f"Welcome {user}! Lab Bot is active.")

async def status(update: Update, context: ContextTypes.DEFAULT_TYPE):
    uptime = os.popen("uptime -p").read()
    await update.message.reply_text(f"📊 Lab Uptime: {uptime}")

async def echo(update: Update, context: ContextTypes.DEFAULT_TYPE):
    await update.message.reply_text(f"Echo: {update.message.text}")

if __name__ == '__main__':
    token = os.environ.get("TELEGRAM_TOKEN")
    
    if not token:
        print("Error: TELEGRAM_TOKEN not found in environment.")
        exit(1)

    app = ApplicationBuilder().token(token).build()

    app.add_handler(CommandHandler("start", start))
    app.add_handler(CommandHandler("status", status))
    app.add_handler(MessageHandler(filters.TEXT & (~filters.COMMAND), echo))

    print("Bot started. Press Ctrl+C to stop (locally) or manage via systemctl.")
    app.run_polling()
