# Whisper Server

Lightweight audio transcription server for VPS, using [whisper.cpp](https://github.com/ggerganov/whisper.cpp) compiled in C++ with a quantized model. Low RAM and CPU usage by design.

## Usage

```bash
# 1. Download the model
./setup.sh

# 2. Start the server
docker compose up -d --build

# 3. Test
curl -X POST http://localhost:8000/inference \
  -F "file=@audio.wav" \
  -F "response_format=json" \
  -F "language=pt"
```

## Configuration

All settings can be adjusted in `Dockerfile` and `docker-compose.yml`.

### Port

The server runs on port **8000** by default. To change it, update both files:

| File                 | What to change                       |
|----------------------|--------------------------------------|
| `Dockerfile`         | `EXPOSE` and `--port` in `CMD`       |
| `docker-compose.yml` | `ports` and `healthcheck` URL        |

### Model

The default model is **small** with **q5_1** quantization (~600MB peak RAM). Available models:

| Model           | Est. RAM | PT-BR Accuracy | File                     |
|-----------------|----------|----------------|--------------------------|
| tiny q5_1       | ~200MB   | Low            | `ggml-tiny-q5_1.bin`    |
| base q5_1       | ~300MB   | Medium         | `ggml-base-q5_1.bin`    |
| small q4_0      | ~500MB   | Good           | `ggml-small-q4_0.bin`   |
| **small q5_1**  | ~600MB   | **Good**       | `ggml-small-q5_1.bin`   |
| medium q5_0     | ~1.5GB   | Very good      | `ggml-medium-q5_0.bin`  |

To switch models, change the file name in:

- `setup.sh` — `MODEL_NAME` variable
- `Dockerfile` — `--model` flag in `CMD`

### Threads

The `--threads` flag in the `Dockerfile` `CMD` controls how many CPU cores whisper uses for inference. Default is **2**. Increase if your VPS has more available cores.

### Resource Limits

In `docker-compose.yml` you can adjust:

```yaml
deploy:
  resources:
    limits:
      cpus: "2.0"    # max CPUs
      memory: 1G     # max RAM
```

### Language

Default is Portuguese (`--language pt`). To change, update the `--language` flag in the `Dockerfile` `CMD`. Use `auto` for automatic detection.
