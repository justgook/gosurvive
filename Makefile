SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

ifdef V
Q=
WGET:=wget
else
Q=@
MAKEFLAGS += --no-print-directory
WGET:=wget -q --show-progress
endif

define QUIET
	$(if $(V), , $(1))
endef


MKDIR_P ?= mkdir -p
CP ?= cp -f

.DEFAULT_GOAL := all

BUILD_DIR ?= build.nosync

clean:
	$(Q)git clean -xdf
	$(Q)rm -rf $(BUILD_DIR)
.PHONY: clean

all: wasm
.PHONY: all

wasm: $(BUILD_DIR)/game.wasm $(BUILD_DIR)/index.html $(BUILD_DIR)/wasm_exec.js
.PHONY: wasm

$(BUILD_DIR)/game.wasm: export GOOS=js
$(BUILD_DIR)/game.wasm: export GOARCH=wasm
$(BUILD_DIR)/game.wasm:
	$(Q)$(MKDIR_P) $(dir $@)
	$(Q)go build -ldflags="-s -w" -o $@

$(BUILD_DIR)/wasm_exec.js:
	$(Q)$(MKDIR_P) $(dir $@)
	$(Q)cp $(shell go env GOROOT)/misc/wasm/wasm_exec.js $@

define INDEX_HTML_CONTENT
<!DOCTYPE html>
<script src="wasm_exec.js"></script>
<script>
// Polyfill
if (!WebAssembly.instantiateStreaming) {
    WebAssembly.instantiateStreaming = async (resp, importObject) => {
        const source = await (await resp).arrayBuffer();
        return await WebAssembly.instantiate(source, importObject);
    };
}

const go = new Go();
WebAssembly.instantiateStreaming(fetch("game.wasm"), go.importObject).then(result => {
    go.run(result.instance);
});
</script>
endef

$(BUILD_DIR)/index.html: export INDEX_HTML_CONTENT:=$(INDEX_HTML_CONTENT)
$(BUILD_DIR)/index.html:
	$(Q)$(MKDIR_P) $(dir $@)
	$(Q)echo "$${INDEX_HTML_CONTENT}" > $@

