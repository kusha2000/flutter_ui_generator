---
tags:
- sentence-transformers
- sentence-similarity
- feature-extraction
- dense
- generated_from_trainer
- dataset_size:19482
- loss:CosineSimilarityLoss
base_model: sentence-transformers/all-mpnet-base-v2
widget:
- source_sentence: Create an order history page with modern light theme using light
    gray background and indigo accent colors. Include 'Order History' title in bold
    indigo text, search bar with subtle shadow, search icon, and 'Search orders...'
    placeholder, and scrollable list of order cards with clean design showing order
    number in gray, date in black, total amount in bold indigo, and chip-style status
    badges (green delivered, yellow pending, red cancelled). List ordered items compactly
    with 'View Details' and 'Reorder' buttons vertically stacked using indigo styling,
    ensuring 16px padding, medium shadow, and rounded corners for modern appearance.
  sentences:
  - Product details screen
  - Professional invoice builder
  - Pixel order tracking page
- source_sentence: Create a user role management interface with a retro-inspired design
    using a warm color palette. The app bar should display 'User Role Management'
    in a serif font on a beige background with a settings icon. Include a search bar
    with a rectangular border and placeholder text 'Search users'. The main content
    should be a scrollable list of user cards with a vintage look, each featuring
    a circular avatar on the left, user name in bold serif font, email in smaller
    brown text, and role badges ('Admin' in red, 'Editor' in orange, 'Viewer' in green)
    on the right. Add an 'Edit Role' button with a brown background at the bottom
    of each card. Use a cream background with textured card backgrounds.
  sentences:
  - Black loading page with neon indicator.
  - Gray prodcut categories grid with professional teal cards.
  - Design health fitness splash screen with clean energetic green and white design,
    health-related heart or fitness icon prominently centered with circular progress
    indicator, app name in modern health-conscious font, motivational tagline, wellness-themed
    background elements promoting vitality and positive energy.
- source_sentence: Red theme PIN screen
  sentences:
  - 'Compact modern tracker: gray background, indigo balance, small category grid,
    compact transactions, coral FAB.'
  - Clean tracker showing metrics and MARK ATTENDANCE button.
  - Build a horizontally-scrollable onboarding experience with multiple screens displayed
    side by side using PageView. Each screen should feature a distinct color scheme
    (green, orange, blue) with matching illustrations and content. Design each page
    with a top illustration area (30% of screen height), large bold heading (30px)
    in the theme color, descriptive paragraph text in dark gray (Colors.grey[800])
    with 16px font size, and navigation elements at the bottom. Include animated page
    indicators (dots) that change color based on the current page, and side-swipe
    navigation arrows. Add a floating action button with 'Start' text that appears
    only on the last page. Implement smooth transitions between pages and ensure consistent
    20px padding on all sides. Each page should have its own themed background gradient.
- source_sentence: 'Health fitness splash screen: clean green-white design, prominent
    heart/fitness icon center with circular progress, modern health-conscious app
    name, motivational tagline, wellness background elements, vitality positive energy
    design.'
  sentences:
  - Yellow login
  - Dark theme language selector
  - 'Design a dark-themed 404 Not Found page with a deep black background (Colors.black87).
    Feature a prominent ''404'' heading in bright white (Colors.white) with a bold
    font weight and font size 80. Below, display ''Oops! Page Not Found'' in a lighter
    gray (Colors.grey[400]) with font size 28 and semi-bold weight. Include a message
    ''It seems the page you’re looking for doesn’t exist or has been moved.'' in small
    white text (font size 14, Colors.white70). Place a vibrant orange ''Return Home''
    button with rounded corners (borderRadius: 12) and white text. Use a Column layout
    with mainAxisAlignment.center and crossAxisAlignment.center. Apply padding of
    32.0 on all sides. Ensure the Scaffold uses the dark background, and add a subtle
    shadow effect to the button using elevation.'
- source_sentence: Search results grid
  sentences:
  - Gradient background file manager with staggered grid.
  - Yellow product Categories cards
  - Black-themed dashboard with metric cards
pipeline_tag: sentence-similarity
library_name: sentence-transformers
---

# SentenceTransformer based on sentence-transformers/all-mpnet-base-v2

This is a [sentence-transformers](https://www.SBERT.net) model finetuned from [sentence-transformers/all-mpnet-base-v2](https://huggingface.co/sentence-transformers/all-mpnet-base-v2). It maps sentences & paragraphs to a 768-dimensional dense vector space and can be used for semantic textual similarity, semantic search, paraphrase mining, text classification, clustering, and more.

## Model Details

### Model Description
- **Model Type:** Sentence Transformer
- **Base model:** [sentence-transformers/all-mpnet-base-v2](https://huggingface.co/sentence-transformers/all-mpnet-base-v2) <!-- at revision e8c3b32edf5434bc2275fc9bab85f82640a19130 -->
- **Maximum Sequence Length:** 384 tokens
- **Output Dimensionality:** 768 dimensions
- **Similarity Function:** Cosine Similarity
<!-- - **Training Dataset:** Unknown -->
<!-- - **Language:** Unknown -->
<!-- - **License:** Unknown -->

### Model Sources

- **Documentation:** [Sentence Transformers Documentation](https://sbert.net)
- **Repository:** [Sentence Transformers on GitHub](https://github.com/UKPLab/sentence-transformers)
- **Hugging Face:** [Sentence Transformers on Hugging Face](https://huggingface.co/models?library=sentence-transformers)

### Full Model Architecture

```
SentenceTransformer(
  (0): Transformer({'max_seq_length': 384, 'do_lower_case': False, 'architecture': 'MPNetModel'})
  (1): Pooling({'word_embedding_dimension': 768, 'pooling_mode_cls_token': False, 'pooling_mode_mean_tokens': True, 'pooling_mode_max_tokens': False, 'pooling_mode_mean_sqrt_len_tokens': False, 'pooling_mode_weightedmean_tokens': False, 'pooling_mode_lasttoken': False, 'include_prompt': True})
  (2): Normalize()
)
```

## Usage

### Direct Usage (Sentence Transformers)

First install the Sentence Transformers library:

```bash
pip install -U sentence-transformers
```

Then you can load this model and run inference.
```python
from sentence_transformers import SentenceTransformer

# Download from the 🤗 Hub
model = SentenceTransformer("sentence_transformers_model_id")
# Run inference
sentences = [
    'Search results grid',
    'Black-themed dashboard with metric cards',
    'Gradient background file manager with staggered grid.',
]
embeddings = model.encode(sentences)
print(embeddings.shape)
# [3, 768]

# Get the similarity scores for the embeddings
similarities = model.similarity(embeddings, embeddings)
print(similarities)
# tensor([[1.0000, 0.2192, 0.2408],
#         [0.2192, 1.0000, 0.2032],
#         [0.2408, 0.2032, 1.0000]])
```

<!--
### Direct Usage (Transformers)

<details><summary>Click to see the direct usage in Transformers</summary>

</details>
-->

<!--
### Downstream Usage (Sentence Transformers)

You can finetune this model on your own dataset.

<details><summary>Click to expand</summary>

</details>
-->

<!--
### Out-of-Scope Use

*List how the model may foreseeably be misused and address what users ought not to do with the model.*
-->

<!--
## Bias, Risks and Limitations

*What are the known or foreseeable issues stemming from this model? You could also flag here known failure cases or weaknesses of the model.*
-->

<!--
### Recommendations

*What are recommendations with respect to the foreseeable issues? For example, filtering explicit content.*
-->

## Training Details

### Training Dataset

#### Unnamed Dataset

* Size: 19,482 training samples
* Columns: <code>sentence_0</code>, <code>sentence_1</code>, and <code>label</code>
* Approximate statistics based on the first 1000 samples:
  |         | sentence_0                                                                         | sentence_1                                                                         | label                                                            |
  |:--------|:-----------------------------------------------------------------------------------|:-----------------------------------------------------------------------------------|:-----------------------------------------------------------------|
  | type    | string                                                                             | string                                                                             | float                                                            |
  | details | <ul><li>min: 4 tokens</li><li>mean: 38.88 tokens</li><li>max: 273 tokens</li></ul> | <ul><li>min: 4 tokens</li><li>mean: 37.36 tokens</li><li>max: 384 tokens</li></ul> | <ul><li>min: 0.25</li><li>mean: 0.46</li><li>max: 0.75</li></ul> |
* Samples:
  | sentence_0                                                                                                                                                                                                                                                                                                                                                                                          | sentence_1                                                                                                                                                                                                                                                                                                                                                                                                                                                       | label             |
  |:----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:------------------|
  | <code>Design a luxurious friend requests page with a black background, a gold-accented app bar, and a scrollable list of cards. Each card has a dark gray background, gold borders, circular profile with gold ring, user name in white, mutual friends in gold, and Accept (gold) and Decline (silver) buttons. Show 5 sample requests with elegant spacing and shadows using a serif font.</code> | <code>Build a dark user search page with search bar, results counter, and vertical cards showing profile image, name, username, followers, and follow button.</code>                                                                                                                                                                                                                                                                                             | <code>0.25</code> |
  | <code>Modern dark-themed invoice with total calculation.</code>                                                                                                                                                                                                                                                                                                                                     | <code>Create a dark-themed invoice generator with black background and green accents. Include a dark grey card with subtle elevation and rounded corners, heading 'Invoice Generator', vertical form fields for company, client, invoice number, date selector, and description. Add an item section with horizontal fields for name, quantity, price. Show a real-time total with green text, and a full-width green gradient 'Generate Invoice' button.</code> | <code>0.75</code> |
  | <code>Clean checkout page order summary forms</code>                                                                                                                                                                                                                                                                                                                                                | <code>Dark blue page with glowing product cards layout.</code>                                                                                                                                                                                                                                                                                                                                                                                                   | <code>0.75</code> |
* Loss: [<code>CosineSimilarityLoss</code>](https://sbert.net/docs/package_reference/sentence_transformer/losses.html#cosinesimilarityloss) with these parameters:
  ```json
  {
      "loss_fct": "torch.nn.modules.loss.MSELoss"
  }
  ```

### Training Hyperparameters
#### Non-Default Hyperparameters

- `num_train_epochs`: 2
- `multi_dataset_batch_sampler`: round_robin

#### All Hyperparameters
<details><summary>Click to expand</summary>

- `overwrite_output_dir`: False
- `do_predict`: False
- `eval_strategy`: no
- `prediction_loss_only`: True
- `per_device_train_batch_size`: 8
- `per_device_eval_batch_size`: 8
- `per_gpu_train_batch_size`: None
- `per_gpu_eval_batch_size`: None
- `gradient_accumulation_steps`: 1
- `eval_accumulation_steps`: None
- `torch_empty_cache_steps`: None
- `learning_rate`: 5e-05
- `weight_decay`: 0.0
- `adam_beta1`: 0.9
- `adam_beta2`: 0.999
- `adam_epsilon`: 1e-08
- `max_grad_norm`: 1
- `num_train_epochs`: 2
- `max_steps`: -1
- `lr_scheduler_type`: linear
- `lr_scheduler_kwargs`: {}
- `warmup_ratio`: 0.0
- `warmup_steps`: 0
- `log_level`: passive
- `log_level_replica`: warning
- `log_on_each_node`: True
- `logging_nan_inf_filter`: True
- `save_safetensors`: True
- `save_on_each_node`: False
- `save_only_model`: False
- `restore_callback_states_from_checkpoint`: False
- `no_cuda`: False
- `use_cpu`: False
- `use_mps_device`: False
- `seed`: 42
- `data_seed`: None
- `jit_mode_eval`: False
- `bf16`: False
- `fp16`: False
- `fp16_opt_level`: O1
- `half_precision_backend`: auto
- `bf16_full_eval`: False
- `fp16_full_eval`: False
- `tf32`: None
- `local_rank`: 0
- `ddp_backend`: None
- `tpu_num_cores`: None
- `tpu_metrics_debug`: False
- `debug`: []
- `dataloader_drop_last`: False
- `dataloader_num_workers`: 0
- `dataloader_prefetch_factor`: None
- `past_index`: -1
- `disable_tqdm`: False
- `remove_unused_columns`: True
- `label_names`: None
- `load_best_model_at_end`: False
- `ignore_data_skip`: False
- `fsdp`: []
- `fsdp_min_num_params`: 0
- `fsdp_config`: {'min_num_params': 0, 'xla': False, 'xla_fsdp_v2': False, 'xla_fsdp_grad_ckpt': False}
- `fsdp_transformer_layer_cls_to_wrap`: None
- `accelerator_config`: {'split_batches': False, 'dispatch_batches': None, 'even_batches': True, 'use_seedable_sampler': True, 'non_blocking': False, 'gradient_accumulation_kwargs': None}
- `parallelism_config`: None
- `deepspeed`: None
- `label_smoothing_factor`: 0.0
- `optim`: adamw_torch
- `optim_args`: None
- `adafactor`: False
- `group_by_length`: False
- `length_column_name`: length
- `project`: huggingface
- `trackio_space_id`: trackio
- `ddp_find_unused_parameters`: None
- `ddp_bucket_cap_mb`: None
- `ddp_broadcast_buffers`: False
- `dataloader_pin_memory`: True
- `dataloader_persistent_workers`: False
- `skip_memory_metrics`: True
- `use_legacy_prediction_loop`: False
- `push_to_hub`: False
- `resume_from_checkpoint`: None
- `hub_model_id`: None
- `hub_strategy`: every_save
- `hub_private_repo`: None
- `hub_always_push`: False
- `hub_revision`: None
- `gradient_checkpointing`: False
- `gradient_checkpointing_kwargs`: None
- `include_inputs_for_metrics`: False
- `include_for_metrics`: []
- `eval_do_concat_batches`: True
- `fp16_backend`: auto
- `push_to_hub_model_id`: None
- `push_to_hub_organization`: None
- `mp_parameters`: 
- `auto_find_batch_size`: False
- `full_determinism`: False
- `torchdynamo`: None
- `ray_scope`: last
- `ddp_timeout`: 1800
- `torch_compile`: False
- `torch_compile_backend`: None
- `torch_compile_mode`: None
- `include_tokens_per_second`: False
- `include_num_input_tokens_seen`: no
- `neftune_noise_alpha`: None
- `optim_target_modules`: None
- `batch_eval_metrics`: False
- `eval_on_start`: False
- `use_liger_kernel`: False
- `liger_kernel_config`: None
- `eval_use_gather_object`: False
- `average_tokens_across_devices`: True
- `prompts`: None
- `batch_sampler`: batch_sampler
- `multi_dataset_batch_sampler`: round_robin
- `router_mapping`: {}
- `learning_rate_mapping`: {}

</details>

### Training Logs
| Epoch  | Step | Training Loss |
|:------:|:----:|:-------------:|
| 0.2053 | 500  | 0.0212        |
| 0.4105 | 1000 | 0.0141        |
| 0.6158 | 1500 | 0.0129        |
| 0.8210 | 2000 | 0.0133        |
| 1.0263 | 2500 | 0.0123        |
| 1.2315 | 3000 | 0.0097        |
| 1.4368 | 3500 | 0.0089        |
| 1.6420 | 4000 | 0.0092        |
| 1.8473 | 4500 | 0.0088        |


### Framework Versions
- Python: 3.12.7
- Sentence Transformers: 5.1.1
- Transformers: 4.57.0
- PyTorch: 2.7.1+cu118
- Accelerate: 1.10.1
- Datasets: 4.0.0
- Tokenizers: 0.22.1

## Citation

### BibTeX

#### Sentence Transformers
```bibtex
@inproceedings{reimers-2019-sentence-bert,
    title = "Sentence-BERT: Sentence Embeddings using Siamese BERT-Networks",
    author = "Reimers, Nils and Gurevych, Iryna",
    booktitle = "Proceedings of the 2019 Conference on Empirical Methods in Natural Language Processing",
    month = "11",
    year = "2019",
    publisher = "Association for Computational Linguistics",
    url = "https://arxiv.org/abs/1908.10084",
}
```

<!--
## Glossary

*Clearly define terms in order to be accessible across audiences.*
-->

<!--
## Model Card Authors

*Lists the people who create the model card, providing recognition and accountability for the detailed work that goes into its construction.*
-->

<!--
## Model Card Contact

*Provides a way for people who have updates to the Model Card, suggestions, or questions, to contact the Model Card authors.*
-->