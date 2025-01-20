import { RunnableLambda } from "@langchain/core/runnables";
import { awaitAllCallbacks } from "@langchain/core/callbacks/promises";

const runnable = RunnableLambda.from(() => "hello!");

const customHandler = {
  handleChainEnd: async () => {
    await new Promise((resolve) => setTimeout(resolve, 2000));
    console.log("Call finished");
  },
};

const start = async  () => {
    const startTime = new Date().getTime();

    await runnable.invoke({ number: "2" }, { callbacks: [customHandler] });

    console.log(`Elapsed time: ${new Date().getTime() - startTime}ms`);

    await awaitAllCallbacks();

    console.log(`Final elapsed time: ${new Date().getTime() - startTime}ms`);
}

start();