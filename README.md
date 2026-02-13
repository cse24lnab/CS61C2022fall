# fa22-lab
## 总体规律（快速定位怎么测）
你这个仓库里的测试主要分三类：

1. **C 代码（.c/.h）**  
   - 通常有 `test_*.c`，要么配 Makefile，要么你手动 `gcc xxx.c test_xxx.c -o xxx` 跑出来看 assert/输出。
2. **RISC‑V 汇编（.s）**  
   - 通常有一个 `*_tester.s` 或者 `main:` 写好了的 driver；一般要用课程指定的模拟器（常见是 Venus）。仓库里没看到模拟器本体，所以这里通常是“用课程工具跑”。
3. **Logisim 电路（.circ）**  
   - 直接用 `python test.py` 调用 `java -jar ..\tools\logisim-evolution.jar ...` 来对拍 `tests/reference-output/*`。

另外：根目录 README.md 基本是空的，没提供统一入口；所以基本是“每个 lab 自己测”。

---

## lab00（环境/初始化类）
目录：lab00
- init.sh：是给 git 课程 starter 用的重置/同步脚本（bash），**不是测试**。
- `gen-debug.sh`：生成 `debug.txt`（bash），用于收集环境信息，**不是单元测试**。
- `code.py`：没有配测试文件；通常是你自己运行/手测。

**怎么测：**
- 如果只是跑 `code.py`，一般就是 `python code.py`（具体看 `code.py` 内容）。
- init.sh / `gen-debug.sh` 在 Windows 下如果没有 WSL / Git Bash，cmd 里跑不了；要么用 Git Bash/WSL，要么手动做同等操作。

---

## lab01（C 小练习，测试就是那些 `test_*.c`）
目录：`lab01/exercise1/2/3`

### exercise1
- `ex1.c` / `ex1.h` + test_ex1.c
- test_ex1.c 里用 `assert()`；跑起来不崩就算过。

**怎么测：**
- 编译并运行 test_ex1.c + `ex1.c`（会生成一个可执行文件，然后直接运行）。

### exercise2
- `pwd_checker.c` / `.h` + test_pwd_checker.c
- 同样是 `assert()` 驱动。

**怎么测：**
- 编译链接 `pwd_checker.c` + test_pwd_checker.c，运行看是否输出 “passed all test cases”。

### exercise3
- `ll_cycle.c` / `.h` + test_ll_cycle.c
- 也是 `assert()` 驱动，包含 `NULL` case。

**怎么测：**
- 编译链接 `ll_cycle.c` + test_ll_cycle.c，运行不崩即过。

> 注：lab01 没有 Makefile，所以要手动编译（或你自己写个 Makefile）。

---

## lab02（C + Makefile：直接 make 出可执行文件跑）
目录：lab02  
有 Makefile，目标很清晰：

- `make all` 会生成并链接：
  - `ll_cycle`（`ll_cycle.c + test_ll_cycle.c`）
  - `bork`（单文件程序 `bork.c`）
  - `vector`（`vector.c + test_vector.c`）
  - `bit_ops`（`bit_ops.c + test_bit_ops.c`）
- 测试方式：这些可执行文件本身就是 tester（多数会 assert / 打印）。

**怎么测：**
- 在 lab02 目录下 `make`，然后逐个运行生成的程序（或直接运行它们看输出/是否退出码异常）。
- `make clean` 清理。

---

## lab03（RISC‑V 汇编：靠 tester 汇编文件/模拟器）
目录：lab03

文件：
- `discrete_fn.s` + discrete_fn_tester.s：tester 会调用 `f` 并打印每个输入的结果（“should be ... and it is ...”）。
- factorial.s：文件里 `main` 会 `jal factorial` 然后 ecall 打印结果；你补 `factorial:` 实现。
- fib.s：自带 `main`，会计算并打印 fib(n)。

**怎么测：**
- 用课程要求的 RISC‑V 模拟器（常见 Venus）。做法一般是：
  - 对 `discrete_fn`：加载 discrete_fn_tester.s（它 `.import discrete_fn.s`），运行看输出是否匹配注释里的 should。
  - 对 factorial.s / fib.s：直接运行文件，看打印结果是否正确。
  
> 仓库里没带 Venus，所以“怎么点/怎么跑”取决于你现在用的工具链（VS Code 插件 / 网页版 Venus / 本地 jar）。如果你告诉我你用的是哪一个（Venus 网页版？还是本地工具？），我可以给你完全对应的点击步骤。

---

## lab04（RISC‑V calling convention：cc_test.s 是测试驱动）
目录：lab04
- cc_test.s：里面对 `pow` / `inc_arr` 做验证；失败会打印 `"%s test failed\n"` 并退出；成功打印 `Tests passed.\n`。
- `ex1.s`、`list_manipulation.s`：属于你要实现的汇编题，测试入口看课程 handout（就仓库文件来看，cc_test.s 是明确的 tester）。

**怎么测：**
- 在模拟器里运行 cc_test.s（它会 `jal pow`、`jal inc_arr`），看到 `Tests passed.` 就过。

---

## lab05（Logisim 电路：`python test.py` 对拍 reference-output）
目录：lab05
- 你的电路：`ex2.circ` `ex3.circ` `ex4.circ`
- 测试电路：`tests/ex2-test.circ` 等
- 参考输出：`tests/reference-output/*.out`
- 测试脚本：test.py（我看过了，它会调用：`java -jar ..\tools\logisim-evolution.jar -tty table,binary,tabs tests\*-test.circ`）

**怎么测：**
- 进入 lab05 运行 `python test.py`
- 它会生成你的输出到 `tests/student-output/*.out`，并和 `reference-output` 对比。

前置条件：
- 需要 `java` 可用
- 需要 `tools/logisim-evolution.jar` 存在（脚本已写死相对路径）

---

## lab06（Logisim 电路：同上，但输出是 CSV）
目录：lab06
- 电路：`ex1.circ` `ex2.circ` `ex3.circ` `ex4.circ`
- 测试脚本：test.py（这版用 `-tty table,binary,csv`）
- 参考输出：`tests/reference-output/*.csv`

**怎么测：**
- 进入 lab06 运行 `python test.py`
- 输出会落到 `tests/student-output/*.csv`

---

## lab07（C + Makefile：ex2 直接跑，ex3 生成可执行文件）
目录：lab07，Makefile 有两个目标：

- `make ex2`：会编译 `matrixMultiply.c` 成 `matrixMultiply`，并且 **立刻运行** `./matrixMultiply`
- `make ex3`：会编译链接 `transpose.o test_transpose.o` 生成 `transpose`（但 Makefile 没自动运行）

**怎么测：**
- `make ex2` 看程序输出/是否正确结束
- `make ex3` 后手动运行 `transpose`（它的 tester 逻辑在 `test_transpose.c`）

> 这个 Makefile 缩进有点怪（用了很多 tab/空格混排），但思路就是这样。

---

## lab08（C + Makefile：生成 simd 可执行文件就是 tester）
目录：lab08
- `make simd`：编译 `simd.c + test_simd.c` 生成 `simd`
- 运行 `simd` 看是否通过（通常 tester 内部 assert / 打印）

---

## lab09（OpenMP C + Makefile：make all 生成 3 个程序）
目录：lab09
- `make` 会生成：`hello` `v_add` `dotp`
- `dotp`/`v_add` 还会链接 `omp_apps.o`
- 测试方式：一般是运行这些程序看输出或性能（仓库里没额外 `test_*.c`）

**怎么测：**
- `make`
- 运行 `hello`/`v_add`/`dotp` 观察输出是否符合预期（具体预期看源码/课程说明）

---

## Windows 上最常见的坑（你现在就是 Windows）
1. **`make` 默认没有**：如果你是纯 cmd/PowerShell 环境，可能需要安装（如 MSYS2/MinGW/WSL）。  
2. **`bash` 脚本（.sh）**：cmd 跑不了，需要 Git Bash/WSL。  
3. **gcc 编译链**：需要 MinGW-w64 / MSYS2 的 gcc，或者 WSL 的 gcc。  
4. **lab05/06 需要 Java**：`java -jar ...` 能跑才行。

---

## 你要我“按你现在电脑”给出一键测试清单的话
我可以直接帮你做两件事（你选一个就行）：

1) 我根据你现在装的工具（gcc/make/java/python 是否存在），给你一套能在 **cmd** 下跑的命令（或告诉你缺什么）。  
2) 我给你加一个仓库根目录的 `run_all_tests.bat`（或 `test-all.ps1`），自动逐个 lab 跑（能跑的就跑，不能跑的给出提示）。

你更想要哪种？如果你告诉我你现在有没有 **WSL / Git Bash / MSYS2**（三选一也行），我就能把命令写到完全可复制的程度。

下面按“会不会被 VPN/密钥影响”的角度，把情况讲清楚：

## 不影响的部分（你现在能跑的大多数测试）
这些测试都在你本机完成，不会去访问学校内网：

- **lab01 / lab02 / lab07 / lab08 / lab09 的 C 测试**  
  本质就是本地 `gcc` 编译 + 运行可执行文件（通过 `assert` 或输出判断）。  
  不需要联网，更不需要 VPN/密钥。

- **lab05 / lab06 的 Logisim 测试（`python test.py`）**  
  它只是本地调用：
  - `python` 跑脚本
  - `java -jar tools/logisim-evolution.jar` 跑电路并对拍 `tests/reference-output/*`  
  这同样不需要 VPN/密钥。

- **lab03 / lab04 的 RISC‑V 汇编测试**  
  一般是用 Venus（网页或本地）之类的模拟器跑 `*_tester.s` 或 cc_test.s。这也是本地/浏览器工具层面，通常不需要学校 VPN。

## 可能会影响的部分（但不是“测试本身”）
真正会需要“学校权限”的，通常是这些环节（你离线做 lab 不一定需要）：

1. **提交作业 / 自动评分（autograder）**
   - 如果课程要求把代码 push 到学校 GitLab/GitHub Classroom，或者在学校服务器上跑 autograder，那可能需要账号权限，有时还需要 VPN。
   - 但这属于“交作业”，不是你本地跑 `test_*.c`/test.py 的那种测试。

2. **拉取私有仓库 / 私有依赖**
   - 你现在仓库内容都在本地了，测试脚本也都在，所以不影响。
   - 只有当你要 `git fetch` 某个学校私有 remote、或者下载工具包（例如课程工具被放在内网）才会卡。

3. **init.sh 这类脚本**
   - init.sh里有 `git fetch starter`、`git push origin ...` 这种操作。  
     如果 `starter` remote 或 `origin` 指向需要权限的仓库，那确实会失败。
   - 但它本来就不是“测试用脚本”，更像课程发放/重置仓库的脚本；你不跑它也不影响做题和本地测试。

## “密钥”到底指什么？
CS61C 语境里常见两种“密钥”：

- **SSH key（git 用）**：用于 push/pull 某些仓库。没有的话，你可能不能推到他们的远程，但不影响你本地编译运行测试。
- **学校账户/API key**：用于访问 autograder/线上服务。starter 里目前看不到这种依赖。

## 你现在最实用的判断方法（1分钟确认）
你只要确认你能在本地满足这些就够了：
- `gcc` / `make`（用于 C labs）
- `python`（用于 lab05/06）
- `java`（用于 logisim jar）

只要这些都 OK，**本地测试就 OK**；VPN/密钥只影响“提交/同步远程”。

如果你愿意，我也可以帮你在当前 Windows 环境里快速检查一下你是否缺 `gcc/make/python/java`（不改任何文件，只做检测），然后我再按你缺啥给最省事的安装建议。你更偏向用 **WSL** 还是 **MSYS2/MinGW**？


## 你本地测试需要的就这三套入口
### 1) C lab（lab01/02/07/08/09）
- 有 Makefile 的：进目录直接 `make`（或 `make ex2` 这种），然后运行生成的可执行文件。
- 没有 Makefile 的（lab01）：用 `gcc 源文件 + test_*.c` 编译，运行即可（`assert` 不报错就 pass）。

### 2) Logisim 电路（lab05/06）
- 进对应目录跑：
  - `python test.py`
- 它会用你本地的 `java` + `tools/logisim-evolution.jar` 对拍参考输出。

### 3) RISC‑V 汇编（lab03/04）
- 用 Venus/你配置好的 RISC‑V 模拟器跑 `*_tester.s` 或 cc_test.s，看输出是否 “Tests passed”。

## VPN/密钥只会在哪影响你？
- **只在你要 push/pull 某些“学校私有仓库/作业提交系统”时**可能需要（比如他们课程的 autograder、学校 GitLab 权限）。
- 你现在这种“把 starter 拉到本地，用 VS Code 打开做题并跑本地测试”，不需要。

如果你接下来想更省事一点，我可以顺手给你整理一份“每个 lab 在 Windows 下最短的测试命令清单”（按你现在目录结构写，避免来回找），你要我按 **cmd** 还是 **PowerShell** 的语法给你？
