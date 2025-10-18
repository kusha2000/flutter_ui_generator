# training_model/training_model_service.py
import os
import pickle
import logging
from sentence_transformers import SentenceTransformer, util
import torch
from typing import Dict, Any, Optional
from datetime import datetime

logger = logging.getLogger(__name__)

class TrainingModelService:
    """
    Loads and queries the local retrieval model (.pkl) for Flutter code suggestions.
    """

    def __init__(self, pkl_path: str = "training_model/flutter_ui_retrieval_model.pkl"):
        self.pkl_path = pkl_path
        self.model_name = None
        self.encoder = None
        self.train_data = []
        self.train_embeddings = None
        self.is_loaded = False

    def load(self) -> bool:
        """Load the saved training model (.pkl)."""
        if not os.path.exists(self.pkl_path):
            logger.error(f"❌ Model file not found: {self.pkl_path}")
            return False

        try:
            logger.info(f"📦 Loading training model from {self.pkl_path} ...")

            with open(self.pkl_path, 'rb') as f:
                package = pickle.load(f)

            self.model_name = package.get("model_name", "all-MiniLM-L6-v2")
            self.train_data = package.get("train_data", [])
            self.train_embeddings = package.get("train_embeddings", None)

            if not isinstance(self.train_embeddings, torch.Tensor):
                try:
                    self.train_embeddings = torch.tensor(self.train_embeddings)
                except Exception:
                    logger.warning("⚠️ Failed to convert embeddings to torch.Tensor")

            self.train_embeddings = self.train_embeddings.to("cpu")
            self.encoder = SentenceTransformer(self.model_name)
            self.is_loaded = True

            logger.info(f"✅ Training model loaded successfully ({len(self.train_data)} samples)")
            return True

        except Exception as e:
            logger.exception(f"❌ Failed to load training model: {e}")
            return False

    def _retrieve(self, query: str, top_k: int = 1, threshold: float = 0.0) -> Optional[Dict[str, Any]]:
        """Retrieve top-matching Flutter code from the dataset."""
        if not self.is_loaded:
            raise RuntimeError("Model not loaded.")

        query_emb = self.encoder.encode(query, convert_to_tensor=True)
        cos_scores = util.pytorch_cos_sim(query_emb, self.train_embeddings)[0]
        top = torch.topk(cos_scores, k=min(top_k, len(self.train_data)))

        for score, idx in zip(top.values, top.indices):
            sim = float(score)
            if sim >= threshold:
                entry = self.train_data[int(idx)]
                return {
                    "prompt": entry.get("prompt"),
                    "code": entry.get("flutter_code"),
                    "category": entry.get("category", "unknown"),
                    "score": sim,
                }
        return None

    def _save_to_training_widget(self, dart_code: str) -> bool:
        """Save generated code to frontend/lib/widgets/training_model_widget.dart"""
        try:
            from pathlib import Path
            
            # Get path to backend directory
            current_dir = Path(__file__).parent.parent
            
            # Navigate to frontend/lib/widgets directory
            frontend_dir = current_dir.parent / "frontend"
            widgets_dir = frontend_dir / "lib" / "widgets"
            target_file = widgets_dir / "training_model_widget.dart"
            
            # Ensure directory exists
            widgets_dir.mkdir(parents=True, exist_ok=True)
            
            # Write the Dart code
            with open(target_file, 'w', encoding='utf-8') as f:
                f.write(dart_code)
            
            logger.info(f"✅ Successfully wrote training model code to: {target_file}")
            return True
            
        except Exception as e:
            logger.error(f"❌ Error writing training widget file: {str(e)}")
            return False

    def get_code(self, prompt: str, top_k: int = 1, threshold: float = 0.0) -> Dict[str, Any]:
        """Public interface — retrieve and save result like other LLMs."""
        svc_name = "training_model"
        widget_name = "TrainingModelGeneratedWidget"

        try:
            retrieved = self._retrieve(prompt, top_k, threshold)

            if not retrieved:
                return {
                    "service": svc_name,
                    "success": False,
                    "error": "No matching code found",
                    "code": None,
                    "widget_name": widget_name,
                    "model": self.model_name,
                    "score": None,
                }

            code = retrieved["code"]
            score = retrieved["score"]

            # Save to training_widget.dart using custom file path
            success = self._save_to_training_widget(code)

            return {
                "service": svc_name,
                "success": success,
                "error": None if success else "File write failed",
                "code": code,
                "widget_name": widget_name,
                "model": self.model_name,
                "score": score,
            }

        except Exception as e:
            logger.exception(f"❌ Error retrieving code: {e}")
            return {
                "service": svc_name,
                "success": False,
                "error": str(e),
                "code": None,
                "widget_name": widget_name,
                "model": self.model_name,
                "score": None,
            }
