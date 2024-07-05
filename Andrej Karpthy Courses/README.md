# Learning Neural Networks

The motivation behind this learning is to go through the entire playlist of Neural Networks: Zero to Hero by Andrej Karpathy to build upon the building blocks of Neural Networks before moving up to building my own transformer, GPT model.

- GitHub: [Neural Networks: Zero to Hero GitHub Repository](https://github.com/karpathy/nn-zero-to-hero/tree/master)
- YouTube Playlist: [Neural Networks: Zero to Hero on YouTube](https://www.youtube.com/watch?v=VMj-3S1tku0&list=PLAqhIrjkxbuWI23v9cThsA9GvCAUhRvKZ&pp=iAQB)

## Building Micrograd
- [Video: Backpropagation and training of neural networks](https://www.youtube.com/watch?v=VMj-3S1tku0&list=PLAqhIrjkxbuWI23v9cThsA9GvCAUhRvKZ)
  - Assumes basic knowledge of Python and a vague recollection of calculus from high school.

## Building Makemore
### Lecture 1: Bigram using Counts
- [Video: The spelled-out intro to language modeling: building makemore
](https://www.youtube.com/watch?v=PaCmpygFfXo)
- We implement a bigram character-level language model, which we will further complexify in followup videos into a modern Transformer language model, like GPT. In this video, the focus is on:
  1. Introducing `torch.Tensor` and its subtleties and use in efficiently evaluating neural networks.
  2. The overall framework of language modeling that includes model training, sampling, and the evaluation of a loss (e.g. the negative log likelihood for classification).

### Lecture 2: MLP Model
- [Video: Building makemore Part 2: MLP
](https://www.youtube.com/watch?v=TCH_1BHY58I&t=574s)
- We implement a multilayer perceptron (MLP) character-level language model. In this video, we also introduce many basics of machine learning, including:
  - Model training
  - Learning rate tuning
  - Hyperparameters
  - Evaluation
  - Train/dev/test splits
  - Under/overfitting

  [Bengio et al. 2003 MLP language model paper](https://www.jmlr.org/papers/volume3/bengio03a/bengio03a.pdf)
