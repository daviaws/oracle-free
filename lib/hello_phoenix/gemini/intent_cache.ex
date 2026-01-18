defmodule HelloPhoenix.Gemini.IntentCache do
  @moduledoc """
  TODO use api and DETS to cached content
  https://generativelanguage.googleapis.com/v1beta/cachedContents
  {
    "model": "models/gemini-1.5-flash-001",
    "display_name": "persona_rei_cientista",
    "system_instruction": {
      "parts": [{
        "text": "Você é o Rei Cientista, portador do Ψ... [Insira aqui toda a sua complexidade e os dados do projeto Prever]"
      }]
    },
    "ttl": "3600s"
  }
  {
    "cached_content": "cachedContents/123abc456",
    "contents": [{
      "parts": [{
        "text": "Analise os focos de calor do Sentinel-2 recebidos agora."
      }]
    }]
  }
  """
end
