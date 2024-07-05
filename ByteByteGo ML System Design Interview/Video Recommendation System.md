# Table of Contents

- Clarifying Questions
- Frame the Problem
   - ML Objective
   - Model Input/Output
- ML Architecture
  - Late Fusion vs Early Fusion
  - Classifier to Use
  - System Architecture
- Data Pipeline
  - Datasets
  - Feature Engineering
- Model Development
- Model Serving

# Context

**Goal:** To design a system that focuses on
- Suggesting videos based on user's homepage based on their profile, previous interactions etc.

# Clarifying Questions

- Can I assume the business objective of building a video recommendation system is to increase user engagement?
- Can I assume users are located worldwide and videos are in different languages?
- Can I assume we can construct the dataset based on user interactions with video content?
- How many videos are available on the platform?
- How fast should the system recommend videos to a user?

# Frame the Problem

## ML Objective
- Maximize the number of **relevant** videos for users based on implicit and explicit user reactions.
- **Relevance** can be such as pressing the "like" button or watching at least half of a video.
- Train a model to **predict** the relevance score between a user and a video.

## Model Input/Output
- **Input**: User + [Secondary Input of Videos]
- **Output**: List of Videos sorted by relevance score


# ML Architecture

## 3 common types of Personalization Recommendation System

1. Content-based filtering
   - Recommend videos similar to videos found to be relevant in the past (E.g. Watched/Liked Ski videos, show ski videos)
   - **Pros**:
     - Ability to recommend videos of unique interest to user
   - **Cons**:
     - Difficult to recommend new videos of different interests
     - Video features required to determine similar ones
2. Collaborative filtering
   - User-user similarities (E.g. User A watched video 1, 2, 3. User B watched video 1, 2. So recommend 3 to User B)
   - **Pros**:
     - 
3. Hybrid filtering

ML models process different modalities independently, then combine their predictions to make a final prediction.

**Advantages:** 
- We can train, evaluate, and improve each model independently.
**Disadvantages:**
- Requires separate training data for each modality, which can be time-consuming and expensive.
- Combination of modalities might be harmful, especially with memes (text + image has a new meaning)

![Early Fusion](images/harmful_content_early_fusion.png)

Modalities are combined first into a fused feature, then the model makes a prediction.

**Advantages:**
- No need for separate training data for each modality; only one model needs training data.
- Model considers all modalities, potentially capturing harmful combinations.
**Disadvantages:** 
- Learning task is more difficult due to complex relationships between modalities, especially without sufficient training data.

Method to use is **EARLY FUSION** as it is more accurate in the event each modality is not harmful on its own, and large user base/posts hence no issue with data.

## Classifier to Use
1. Binary Classifier
   - Takes fused feature as input, predicts probablity harmful
     - Does not provide clue/hint which class of harm it belongs to, to inform user
     - Unable to improve sytem based on underperforming types of hamrful content
2. Binary Classifier for each harmful class
   - Each class has its own model, all takes the fused feature as input
     - Drawback is multiple model needs own maintanence and trianing
     - Time consuming and expensive
3. Multi-class Classifier
   - Takes fused feature as input, predicts probability of each harmful class
     - However each class might actually require the features to be transformed/fitted differently, not good to use a single generalized model
4. **Multi-Headed Classifier**
    - Single model learns different tasks simultaneously
    - Balance between training and efficiency

## System Architecture
![System Architecture using Multi-headed Classifier](images/harmful_content_system_architecture.png)

# Data Pipeline

## Datasets

1. User Data Schema
   - Using TikTok account as an example:

| User ID | Username | Following | Followers | Likes | Description |
| ------- | -------- | --------- | --------- | ----- | ----------- |
| ...     | ...      | ...       | ...       | ...   | ...         |

1. Post Data

| Post ID | Author ID | Timestamp | Description | Video | Likes | Number Comments | Number Saves |
| ------- | --------- | --------- | ----------- | ----- | ----- | --------------- | ------------ |
| ...     | ...       | ...       | ...         | ...   | ...   | ...             | ...          |

3. User-post Interaction Data

  | User ID | Post ID | Interaction type | Interaction value  | Timestamp  |
  | ------- | ------- | ---------------- | ------------------ | ---------- |
  | 4       | 20      | Like             | -                  | 1658451341 |
  | 11      | 7       | Comment          | This is disgusting | 1658451365 |

## Feature Engineering

**Post Features**

1. Textual Content:
   - Comments, DEscription etc
   - Vectorization: Embedding Models
     - Better than statistical models like TF-IDF or Bag of Words, which does not capture semantic meanings
2. Image/Video Content:
   - Convert unstructured data into a feature vector.
   - For images, options include pre-trained models like CLIP's visual encoder
     - Component of the CLIP (Contrastive Language-Image Pre-training) model developed by OpenAI
   - For videos, models such as VideoMoCo could be effective.
     - Self-supervised learning framework introduced by researchers at Facebook AI Research (FAIR) for learning representations from images without human annotations
3. Numerical Content:
   - Number of likes etc, scale them

**Author Features**

1. Author's violation history
   - Number of violations
   - Total user reports
2. Author's demographics
   - Age
   - Gender, etc
3. Number of followers etc

![Feature Engineering](images/harmful_content_feature_engineering.png)

# Model Development

## Model Selection:
- Neural networks are commonly used for multi-task learning.
  - MBMT-Net
- Hyperparameter tuning, often done via grid search, is crucial for finding optimal hyperparameter values.
  - Optuna

## Model Training:
### Constructing the Dataset:
- Dataset comprises inputs (features) and outputs (labels).
- Features are computed offline in batches, while labels can be obtained through hand labeling or natural labeling.
- Hand labeling is accurate but expensive, while natural labeling is quicker but produces noisier labels.

### Choosing the Loss Function:
- For binary classification tasks, standard loss functions like cross-entropy are commonly used.
- Overall loss is computed by combining task-specific losses.

## Challenges and Techniques:
- Overfitting is a common challenge in training multimodal systems.
- Techniques to address overfitting include gradient blending and focal loss.

# Model Evaluation

## Offline
- ROC Curve:
  - ROC curves plot the true positive rate (TPR) against the false positive rate (FPR) at various classification thresholds.
  - AUC (Area Under the Curve) summarizes the ROC curve into a single value, indicating the model's ability to distinguish between classes.
  - ROC curves are less sensitive to class imbalance but may not be ideal for imbalanced datasets or multi-label classification tasks.

- Precision-Recall Curve:
  - Precision-recall curves plot precision against recall at various classification thresholds.
  - AUC-PR (Area Under the Precision-Recall curve) summarizes the precision-recall curve into a single value, indicating the model's ability to prioritize true positives while minimizing false positives.

## Online
1. **Prevalence**:
   - Prevalence measures the ratio of harmful posts that were not prevented to all posts on the platform.
   - Formula: `Prevalence = Number of harmful posts we didn't prevent / Total number of posts on the platform`
   - Shortcoming: It treats all harmful posts equally and does not account for the impact of each post.

2. **Valid Appeals**:
   - Valid appeals represent the percentage of posts initially deemed harmful but later appealed and reversed.
   - Formula: `Valid Appeals = Number of reversed appeals / Number of harmful posts detected by the system`
   - It indicates the effectiveness of the appeals process in correcting false positives.

3. **Proactive Rate**:
   - Proactive rate measures the percentage of harmful posts detected and deleted by the system before users report them.
   - Formula: `Proactive Rate = Number of harmful posts detected by the system / (Number of harmful posts detected by the system + reported by users)`
   - It reflects the system's ability to identify and remove harmful content proactively.

# Model Serving

![Model Serving](images/harmful_content_model_serving.png)