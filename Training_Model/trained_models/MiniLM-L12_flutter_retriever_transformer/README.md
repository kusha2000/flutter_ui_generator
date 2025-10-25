---
tags:
- sentence-transformers
- sentence-similarity
- feature-extraction
- dense
- generated_from_trainer
- dataset_size:19482
- loss:CosineSimilarityLoss
base_model: sentence-transformers/all-MiniLM-L12-v2
widget:
- source_sentence: 'Create a vibrant quiz results page with a modern, light theme.
    The page should feature a bold header with ''Quiz Completed!'' in large, teal-colored
    text at the top. Below, display a circular progress indicator showing an 85% score,
    with a bold percentage text inside a teal-bordered circle. Include a results summary
    card with a subtle shadow, showing the total score (17/20), time taken (5m 23s),
    and accuracy percentage in a clean, tabular format. Add three action buttons in
    a horizontal row: ''Review Answers'' (teal), ''Retake Quiz'' (gray), and ''Share
    Results'' (orange), each with rounded corners. Include a breakdown section with
    correct answers in green, incorrect in red, and skipped in yellow, using circular
    icons for visual clarity. Use a white background, teal accents, and generous spacing
    for a clean look.'
  sentences:
  - 'Minimal natural Help Center: soft green base, forest green title, beige rounded
    search field, olive buttons, and earthy FAQ/Contact design.'
  - Colorful file manager UI
  - Dark theme contact Support
- source_sentence: Create a vibrant products list interface with a vertical scrollable
    layout. Each product card should feature a large circular icon placeholder at
    the top, product name in bold black typography, a short description in dark gray,
    and the price in purple. Include an 'Add to Cart' button with an orange background
    and rounded corners. Use a gradient scaffold background (from light blue to white)
    and cards with bold shadows. Ensure 20px padding around the list and 16px between
    cards. The app bar should have a gradient background matching the scaffold and
    a white title.
  sentences:
  - Energetic rounded category cards
  - Warm beige dashboard with vertical metrics
  - Monochrome Minimal Calendar
- source_sentence: Design a privacy policy page with a gradient background transitioning
    from light purple to white for a modern, visually appealing effect. Place a 'Privacy
    Policy' title at the top in a large, bold dark purple font, centered. Include
    a back button in the top-right corner with a dark purple icon. Below the title,
    add a brief introductory paragraph in dark gray text. Create four sections with
    subheadings ('Data Collection', 'Data Use', 'Data Protection', 'Contact Us') in
    bold dark purple text, each followed by a paragraph in dark gray text. Use 20-pixel
    padding and 24-pixel spacing between sections. At the bottom, place an 'Accept'
    button with a dark purple background and white text, and a 'Decline' button with
    a transparent background and dark purple border, centered. The layout should be
    scrollable with a Column layout.
  sentences:
  - Design a clean, centered rating interface with gradient app icon, title, short
    description, interactive stars, and two action buttons.
  - Purple grid settings with profile avatar
  - Pink colur theme Privacy Policy
- source_sentence: Horizontal user roles cards
  sentences:
  - Professional Camera Page
  - Search cards horizontal
  - Consumer Mobile Splash Screen
- source_sentence: Create a white search results page with a top search bar, results
    counter, and vertical list of product cards. Each card has light gray background,
    image placeholder, bold title, green price, star rating, brief description, and
    a blue 'View Details' button.
  sentences:
  - Design a playful, colorful search page with a top search bar with orange border,
    pastel filter chips, single-column product cards with images, titles, prices,
    star ratings, and a bottom-centered floating filter button.
  - Light themed profile editor with circular avatar image
  - Top 404 page
pipeline_tag: sentence-similarity
library_name: sentence-transformers
---

# SentenceTransformer based on sentence-transformers/all-MiniLM-L12-v2

This is a [sentence-transformers](https://www.SBERT.net) model finetuned from [sentence-transformers/all-MiniLM-L12-v2](https://huggingface.co/sentence-transformers/all-MiniLM-L12-v2). It maps sentences & paragraphs to a 384-dimensional dense vector space and can be used for semantic textual similarity, semantic search, paraphrase mining, text classification, clustering, and more.

## Model Details

### Model Description
- **Model Type:** Sentence Transformer
- **Base model:** [sentence-transformers/all-MiniLM-L12-v2](https://huggingface.co/sentence-transformers/all-MiniLM-L12-v2) <!-- at revision c004d8e3e901237d8fa7e9fff12774962e391ce5 -->
- **Maximum Sequence Length:** 128 tokens
- **Output Dimensionality:** 384 dimensions
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
  (0): Transformer({'max_seq_length': 128, 'do_lower_case': False, 'architecture': 'BertModel'})
  (1): Pooling({'word_embedding_dimension': 384, 'pooling_mode_cls_token': False, 'pooling_mode_mean_tokens': True, 'pooling_mode_max_tokens': False, 'pooling_mode_mean_sqrt_len_tokens': False, 'pooling_mode_weightedmean_tokens': False, 'pooling_mode_lasttoken': False, 'include_prompt': True})
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
    "Create a white search results page with a top search bar, results counter, and vertical list of product cards. Each card has light gray background, image placeholder, bold title, green price, star rating, brief description, and a blue 'View Details' button.",
    'Top 404 page',
    'Design a playful, colorful search page with a top search bar with orange border, pastel filter chips, single-column product cards with images, titles, prices, star ratings, and a bottom-centered floating filter button.',
]
embeddings = model.encode(sentences)
print(embeddings.shape)
# [3, 384]

# Get the similarity scores for the embeddings
similarities = model.similarity(embeddings, embeddings)
print(similarities)
# tensor([[1.0000, 0.2510, 0.7228],
#         [0.2510, 1.0000, 0.2507],
#         [0.7228, 0.2507, 1.0000]])
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
  | details | <ul><li>min: 4 tokens</li><li>mean: 34.02 tokens</li><li>max: 128 tokens</li></ul> | <ul><li>min: 4 tokens</li><li>mean: 31.54 tokens</li><li>max: 128 tokens</li></ul> | <ul><li>min: 0.25</li><li>mean: 0.45</li><li>max: 0.75</li></ul> |
* Samples:
  | sentence_0                                                                                                                                                                                                                                                                                                                | sentence_1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               | label             |
  |:--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:------------------|
  | <code>Dark contact support page: grey background, white/grey text, bright white title, light grey subtitle, form fields (name, email, subject, priority, description) with icons and dark styling, contact methods cards (email, phone, chat) in orange theme with response times, orange 'Submit Request' button.</code> | <code>Colorful About us page</code>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      | <code>0.25</code> |
  | <code>Digital Timer Interface</code>                                                                                                                                                                                                                                                                                      | <code>Design a task manager page with a nature-inspired theme. Include a top app bar with the title 'Nature Tasks' in a bold, organic font and a notification icon. Place a floating action button with a plus icon at the bottom-right. Display a scrollable list of task cards, each with a checkbox, a bold task title, a description in smaller text, a priority badge (red=high, orange=medium, green=low), and a due date with a leaf icon instead of a calendar. Include a three-dot menu on the right. Use a light green background, soft card shadows, and an olive green primary color scheme. Include a bottom navigation bar with 'Tasks', 'Projects', and 'Profile' tabs, using olive green icons. Ensure the layout is responsive, follows Material Design, and evokes a natural, earthy aesthetic.</code> | <code>0.75</code> |
  | <code>Build an expense tracker page featuring bold balance, horizontal category cards, transaction list with icons, and a floating action button on a modern white background.</code>                                                                                                                                     | <code>Cream color search product cards</code>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            | <code>0.25</code> |
* Loss: [<code>CosineSimilarityLoss</code>](https://sbert.net/docs/package_reference/sentence_transformer/losses.html#cosinesimilarityloss) with these parameters:
  ```json
  {
      "loss_fct": "torch.nn.modules.loss.MSELoss"
  }
  ```

### Training Hyperparameters
#### Non-Default Hyperparameters

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
- `num_train_epochs`: 3
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
| 0.2053 | 500  | 0.0242        |
| 0.4105 | 1000 | 0.0148        |
| 0.6158 | 1500 | 0.0137        |
| 0.8210 | 2000 | 0.0129        |
| 1.0263 | 2500 | 0.013         |
| 1.2315 | 3000 | 0.0103        |
| 1.4368 | 3500 | 0.01          |
| 1.6420 | 4000 | 0.0099        |
| 1.8473 | 4500 | 0.0107        |
| 2.0525 | 5000 | 0.0103        |
| 2.2578 | 5500 | 0.0085        |
| 2.4631 | 6000 | 0.0089        |
| 2.6683 | 6500 | 0.008         |
| 2.8736 | 7000 | 0.0085        |


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