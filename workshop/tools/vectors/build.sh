#!/bin/sh
# Builds what hour 4 searches by meaning with, into workshop/inputs/hour-4/memory/:
#   minilm.bin                  the model, from the Hugging Face files of
#                               sentence-transformers/all-MiniLM-L6-v2 (Apache 2.0)
#   bin/vectors-darwin-<arch>   the program for a Mac, Apple chip (arm64) or Intel (amd64),
#                               one file, no library needed.
#   bin/vectors-windows-amd64.exe  the same program for Windows, run from Git's sh.
#   sh workshop/tools/vectors/build.sh <folder with model.safetensors and vocab.txt>
# Needs Go. Plain Go, no C, so another system is one more line in the loop below.
set -eu
hf=${1:?usage: sh workshop/tools/vectors/build.sh <hugging face folder>}
here=$(cd "$(dirname "$0")" && pwd)
out=$(cd "$here/../../inputs/hour-4/memory" && pwd)
go -C "$here" run ./convert "$hf" "$out/minilm.bin"
mkdir -p "$out/bin"
for target in darwin/arm64 darwin/amd64 windows/amd64; do
  os=${target%/*} arch=${target#*/}
  file="$out/bin/vectors-$os-$arch"
  if [ "$os" = windows ]; then file="$file.exe"; fi
  # -trimpath and no build id: the files carry no path of this laptop.
  GOOS=$os GOARCH=$arch CGO_ENABLED=0 go -C "$here" build -trimpath -ldflags '-s -w -buildid=' -o "$file" .
  printf '%s\n' "${file#"$out"/}"
done
# step-4 of hour 4 carries its own copy of the memory folder.
cp "$out"/bin/vectors-* "$out/../step-4/memory/bin/"
