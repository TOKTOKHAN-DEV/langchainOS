import { ChatOpenAI } from "@langchain/openai";

import { StringOutputParser } from "@langchain/core/output_parsers";
import { ChatPromptTemplate } from "@langchain/core/prompts";
import { config } from "dotenv";
import path from "path";

config({ path: path.resolve(__dirname, "../../../.env") });

const startAgents = async  () => {
    const model = new ChatOpenAI({
      model: "gpt-4o-mini",
      temperature: 0
    });

    const prompt = ChatPromptTemplate.fromTemplate("tell me a joke about {topic}");
    const chain = prompt.pipe(model).pipe(new StringOutputParser());

    await chain.invoke({ topic: "bears" });
}

startAgents().catch((error) => {
    console.error("Unhandled error in startAgents:", error);
    process.exit(1);
});