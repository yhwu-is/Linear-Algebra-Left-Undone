MAIN_DIR = 讲义
MAIN_FILENAME = 线性代数荣誉课辅学讲义
ANSWERS_DIR = 习题参考答案
ANSWERS_FILENAME = 线性代数荣誉课辅学习题答案

GH_ACTIONS_DIR = gh-actions-build

.PHONY: all gh-actions main ans clean

all: main ans

gh-actions: all
# used by GitHub Actions
	mkdir -p $(GH_ACTIONS_DIR)
	cp $(MAIN_DIR)/$(MAIN_FILENAME).pdf $(ANSWERS_DIR)/$(ANSWERS_FILENAME).pdf $(GH_ACTIONS_DIR)

main:
	$(MAKE) -C $(MAIN_DIR)

ans:
	$(MAKE) -C $(ANSWERS_DIR)

clean:
	# Cleaning...
	$(MAKE) -C $(MAIN_DIR) clean
	$(MAKE) -C $(ANSWERS_DIR) clean
	rm -rf $(GH_ACTIONS_DIR)
