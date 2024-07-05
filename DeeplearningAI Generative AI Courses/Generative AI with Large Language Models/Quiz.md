## Week 1 Quiz

**1.** Interacting with Large Language Models (LLMs) differs from traditional machine learning models. Working with LLMs involves natural language input, known as a _____, resulting in output from the Large Language Model, known as the ______.

Choose the answer that correctly fill in the blanks.
- [ ] tunable request, completion
- [x] prompt, completion
- [ ] prediction request, prediction response
- [ ] prompt, fine-tuned LLM

**2.** Large Language Models (LLMs) are capable of performing multiple tasks supporting a variety of use cases. Which of the following tasks supports the use case of converting code comments into executable code?
- [x] Translation
- [ ] Information Retrieval
- [ ] Text summarization
- [ ] Invoke actions from text

**3.** What is the self-attention that powers the transformer architecture?
- [ ] The ability of the transformer to analyze its own performance and make adjustments accordingly.
- [x] A mechanism that allows a model to focus on different parts of the input sequence during computation.
- [ ] A measure of how well a model can understand and generate human-like language.
- [ ] A technique used to improve the generalization capabilities of a model by training it on diverse datasets.

**4.** Which of the following stages are part of the generative AI model lifecycle mentioned in the course? (Select all that apply)
- [x] Deploying the model into the infrastructure and integrating it with the application.
- [x] Defining the problem and identifying relevant datasets.
- [ ] Performing regularization
- [x] Manipulating the model to align with specific project needs.
- [x] Selecting a candidate model and potentially pre-training a custom model.

**5.** "RNNs are better than Transformers for generative AI Tasks."

Is this true or false?
- [ ] True
- [x] False

**6.** Which transformer-based model architecture has the objective of guessing a masked token based on the previous sequence of tokens by building bidirectional representations of the input sequence.
- [x] Autoencoder
- [ ] Autoregressive
- [ ] Sequence-to-sequence

**7.** Which transformer-based model architecture is well-suited to the task of text translation?
- [ ] Autoencoder
- [ ] Autoregressive
- [x] Sequence-to-sequence

**8.** Do we always need to increase the model size to improve its performance?
- [ ] True
- [x] False

**9.** Scaling laws for pre-training large language models consider several aspects to maximize performance of a model within a set of constraints and available scaling choices. Select all alternatives that should be considered for scaling when performing model pre-training?
- [ ] Batch size: Number of samples per iteration 
- [x] Model size: Number of parameters
- [x] Dataset size: Number of tokens
- [x] Compute budget: Compute constraints

**10.** "You can combine data parallelism with model parallelism to train LLMs."

Is this true or false?
- [x] True
- [ ] False

## Week 2 Quiz

**1.** Fill in the blanks: __________ involves using many prompt-completion examples as the labeled training dataset to continue training the model by updating its weights.  This is different from _________ where you provide prompt-completion examples during inference.
- [ ] In-context learning, Instruction fine-tuning 
- [ ] Prompt engineering, Pre-training
- [ ] Pre-training, Instruction fine-tuning
- [x] Instruction fine-tuning, In-context learning

**2.** Fine-tuning a model on a single task can improve model performance specifically on that task; however, it can also degrade the performance of other tasks as a side effect. This phenomenon is known as:
- [ ] Catastrophic loss
- [x] Catastrophic forgetting
- [ ] Instruction bias
- [ ] Model toxicity

**3.** Which evaluation metric below focuses on precision in matching generated output to the reference text and is used for text translation?
- [ ] HELM
- [x] BLEU
- [ ] ROUGE-2
- [ ] ROUGE-1

**4.** Which of the following statements about multi-task finetuning is correct? Select all that apply:
- [ ] Performing multi-task finetuning may lead to slower inference.
- [x] Multi-task finetuning can help prevent catastrophic forgetting.
- [x] FLAN-T5 was trained with multi-task finetuning.
- [ ] Multi-task finetuning requires separate models for each task being performed.

**5.** "Smaller LLMs can struggle with one-shot and few-shot inference:"

Is this true or false?
- [x] True
- [ ] False

**6.** Which of the following are Parameter Efficient Fine-Tuning (PEFT) methods? Select all that apply.
- [x] Reparametrization
- [ ] Subtractive
- [x] Selective
- [x] Additive

**7.** Which of the following best describes how LoRA works?
- [x] LoRA decomposes weights into two smaller rank matrices and trains those instead of the full model weights.
- [ ] LoRA freezes all weights in the original model layers and introduces new components which are trained on new data.
- [ ] LoRA trains  a smaller, distilled version of the pre-trained LLM to reduce model size
- [ ] LoRA continues the original pre-training objective on new data to update the weights of the original model.

**8.** What is a soft prompt in the context of LLMs (Large Language Models)?
- [x] A set of trainable tokens that are added to a prompt and whose values are updated during additional training to improve performance on specific tasks.
- [ ] A strict and explicit input text that serves as a starting point for the model's generation.
- [ ] A technique to limit the creativity of the model and enforce specific output patterns.
- [ ] A method to control the model's behavior by adjusting the learning rate during training.

**9.** "Prompt Tuning is a technique used to adjust all hyperparameters of a language model."

Is this true or false?
- [ ] True
- [x] False

**10.** "PEFT methods can reduce the memory needed for fine-tuning dramatically, sometimes to just 12-20% of the memory needed for full fine-tuning."

Is this true or false?
- [x] True
- [ ] False

## Week 3 Quiz

**1.** Which of the following are true in regards to Constitutional AI? Select all that apply.
- [x] Red Teaming is the process of eliciting undesirable responses by interacting with a model.
- [ ] For constitutional AI, it is necessary to provide human feedback to guide the revisions.
- [x] To obtain revised answers for possible harmful prompts, we need to go through a Critique and Revision process.
- [x] In Constitutional AI, we train a model to choose between different prompts.

**2.** What does the "Proximal" in Proximal Policy Optimization refer to?
- [ ] The algorithm's ability to handle proximal policies
- [ ] The algorithm's proximity to the optimal policy
- [ ] The use of a proximal gradient descent algorithm
- [x] The constraint that limits the distance between the new and old policy

**3.** "You can use an algorithm other than Proximal Policy Optimization to update the model weights during RLHF."

Is this true or false?
- [x] True
- [ ] False

**4.** In reinforcement learning, particularly with the Proximal Policy Optimization (PPO) algorithm, what is the role of KL-Divergence? Select all that apply.
- [x] KL divergence measures the difference between two probability distributions.
- [x] KL divergence is used to enforce a constraint that limits the extent of LLM weight updates.
- [ ] KL divergence encourages large updates to the LLM weights to increase differences from the original model.
- [ ] KL divergence is used to train the reward model by scoring the difference of the new completions from the original human-labeled ones.

**5.** Fill in the blanks: When fine-tuning a large language model with human feedback, the action that the agent (in this case the LLM) carries out is ________ and the action space is the _________.
- [x] Generating the next token, vocabulary of all tokens.
- [ ] Processing the prompt, context window.
- [ ] Calculating the probability distribution, the LLM model weights.
- [ ] Generating the next token, the context window

**6.** How does Retrieval Augmented Generation (RAG) enhance generation-based models?
- [ ] By applying reinforcement learning techniques to augment completions. 
- [x] By making external knowledge available to the model
- [ ] By increasing the training data size.
- [ ] By optimizing model architecture to generate factual completions.

**7.** How can incorporating information retrieval techniques improve your LLM application? Select all that apply.
- [x] Overcome Knowledge Cut-offs
- [ ] Faster training speed when compared to traditional models
- [ ] Reduced memory footprint for the model
- [x] Improve relevance and accuracy of responses

**8.** What is a correct definition of Program-aided Language (PAL) models?
- [x] Models that offload computational tasks to other programs.
- [ ] Models that integrate language translation and coding functionalities.
- [x] Models that assist programmers in writing code through natural language interfaces.
- [ ] Models that enable automatic translation of programming languages to human languages.

**9.** Which of the following best describes the primary focus of ReAct?
- [ ] Investigating reasoning abilities in LLMs through chain-of-thought prompting.
- [ ] Studying the separate topics of reasoning and acting in LLMs.
- [ ] Exploring action plan generation in LLMs.
- [x] Enhancing language understanding and decision making in LLMs.

**10.** What is the main purpose of the LangChain framework?
- [x] To chain together different components and create advanced use cases around LLMs, such as chatbots, Generative Question-Answering (GQA), and summarization.
- [ ] To evaluate the LLM's completions and provide fast prototyping and deployment capabilities.
- [ ] To connect with external APIs and datasets and offload computational tasks.
- [ ] To provide prompt templates, agents, and memory components for working with LLMs.
