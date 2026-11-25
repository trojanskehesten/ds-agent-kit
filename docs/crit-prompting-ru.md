# CRIT-промпт, Meta-layer и практики для Agentic Data Analysis

## Общий флоу: с чего начинать анализ

В агентном EDA есть две точки входа — выбор зависит от того, насколько чётко сформулирована ваша задача:

1. **Нет чёткой гипотезы / новый незнакомый датасет / размытый запрос бизнеса («посмотри, что там интересного»)**
   `Шаг 0 (Meta-layer: 5 исследовательских вопросов)` → выбираете 1–2 направления → `Шаг 1 (CRIT + plan-jupyter)` → `Шаг 2 (Итерации / Interview)` → фиксация выводов в ноутбуке.

2. **Есть конкретная гипотеза, утверждение стейкхолдера или эксперимент для проверки**
   Сразу `Шаг 1 (CRIT + plan-jupyter)` → `Шаг 2 (Итерации / Interview)` → фиксация выводов в ноутбуке.

## Шаг 0 (Опционально): Meta-layer — разведка и генерация гипотез

### Что это такое и когда применять

**Meta-layer** — это предварительный шаг, на котором вы не просите агента сразу анализировать данные или писать длинный код, а просите сначала осмотреть доступные таблицы и предложить **список из 5 возможных исследовательских вопросов** (или направлений анализа).

**Когда это нужно:**

* Вы впервые видите новый датасет (особенно если таблиц несколько) и ещё не понимаете, какие вопросы на этих данных вообще решаемы.
* Пришёл размытый запрос («найди точки роста», «помоги улучшить бизнес-процессы»).
* Нужно избежать **туннельного зрения** и не дать агенту с первой же ячейки уйти по ложному или малоценному пути.
* Вы хотите оставить за собой роль архитектора (human-in-the-loop): агент генерирует варианты на основе реальной структуры данных, а вы выбираете, куда копать.

### Пример промпта из вебинара DataCamp

```text
Context:
Look at my lakehouse. You'll note I have 9 tables. The data comes from a South American e-commerce company and the orders span approx 2016 to 2018. You should assume the data is accurate but it's a good idea to verify any assumptions by actually querying the data.

Role:
You are a business analyst with 10 years of experience helping retailers and e-commerce companies improve their business processes. You are starting a new consulting gig and you were given the above context about the data you want to use to help this company improve their business. You have no additional information about this company.

Interview:
I am the CEO of this company. I want YOU to give me a list of FIVE potential research questions that you believe would be answerable given the datasets above. After you give those to me I will pick a few with you and ask you to dive deeper.

Go!
```

### Почему этот промпт работает (разбор)

* **`verify any assumptions by actually querying the data`** — критическая фраза: она не даёт модели придумывать вопросы «из головы» по одним лишь названиям файлов/таблиц, а заставляет реально проверить схемы, связи и наличие нужных колонок.
* **`list of FIVE potential research questions`** — фиксированное число (обычно 3–5) даёт хороший баланс: достаточно широко, чтобы увидеть неочевидные углы, но без «простыни» из 20 банальностей.
* **`After you give those to me I will pick a few`** — жёсткий стоп-кран: агент обязан остановиться после списка и ждать вашего выбора, прежде чем переходить к глубокому анализу.

### Драфт Meta-layer промпта (шаблон для заполнения)

```text
Context:
Look at the data located at [Укажите папку / базу / список таблиц, например: data/raw/ с 5 таблицами].
The data comes from [Краткое описание домена, продукта и временного периода, например: B2C SaaS, события за 2024–2025 гг.].
You should assume the data is generally accurate, but verify any assumptions (schemas, keys, date ranges, null rates) by actually querying/inspecting the data first.

Role:
You are a [Укажите роль, например: senior product data scientist / business analyst] with 10 years of experience in [Укажите домен]. You are starting a new engagement with only the context above and no additional background on the company.

Interview:
I am a [Ваша роль, например: Senior DS / Head of Product].
Before running any deep analysis or plotting, inspect the available datasets and give me a list of FIVE high-impact potential research questions (or hypotheses) that are actually answerable given these tables. For each question, briefly note which tables/columns support it and what business decision it could inform.
After you give me the list, stop and wait — I will pick 1–2 questions with you, and then we will dive deeper.
```

## Шаг 1: Стартовый CRIT-промпт (проверка гипотезы и `plan-jupyter`)

### Пример промпта из вебинара DataCamp

```text
Context:
Here is my business problem. We just held a c suite meeting to discuss our marketing strategy. Our CMO made this statement:
> “Last quarter was the best quarter in out history. We crushed Wall Streets earning targets by a wide margin. I am POSITIVE that the key reason was our revamped digital advertising campaigns. Recently we conducted a comprehensive survey of our social media usage at our mall stores and it is apparent our Instagram presence is expanding. 52% of survey respondents said they learned about our company from Instagram. We should double down on our Instagram ads to continue our earnings trajectory.”

Everyone in the room, including me, was skeptical. But we need hard data and analytics to prove it.

Role:
You are a marketing analytics data scientist with 10 years of experience in the retail space. I want you to help me look through the data and, using your intuition and experience, help me understand if the CMO’s statements are correct.

Interview:
I am the CEO of this retailer. I want you to interview me and let’s look at this data together. I want YOU to ask me questions about my business, goals, etc, and let’s reason through this problem together. Feel free to ask me any questions that may help you dive deeper and offer better recommendations. Work with me in a step-wise manner. Let’s look at each step together. Assume I know nothing about data, analytics, and what a data scientist is or does.

Task:
Should we invest more money in Instagram ad spend? Or something else? How much should we spend on Instagram ads? Tell me what you are thinking at each step of the process and ask any follow-on questions as needed.

The survey data is in a Microsoft Fabric table in a lakehouse attached to this notebook called “dbo.marketing_surveys”. I’m not sure what’s in this table, but this is the data our CMO gave to us.
```

### Драфт стартового CRIT-промпта (шаблон для заполнения)

Замените текст внутри квадратных скобок `[]` на детали вашей задачи (или вставьте выбранный вопрос из Шага 0). В блоках с выбором оставьте один подходящий вариант:

```text
Context:
Here is my problem / hypothesis: [Опишите бизнес-контекст, задачу или утверждение, которое нужно проверить].
[Опишите, в чём заключается скепсис, какие есть риски или альтернативные объяснения, чтобы агент искал слабые места, а не поддакивал].
We need hard data and rigorous statistical analysis to verify or refute this.

Experiment / Data collection protocol (if applicable):
- [Как именно собирались данные или был устроен эксперимент: сплитование, длительность, участники, условия]
- [Известные ограничения процесса сбора, чтобы агент сразу проверил дизайн на конфаундеры и дрейф]

Role:
You are a [Укажите узкую специализацию, например: senior data scientist / product analyst] with 10 years of experience in [Укажите домен / индустрию]. We've brought you in to help us make this decision — or show us what we should be thinking about or doing wrong. Using your domain intuition and statistical rigor, evaluate whether [Укажите ключевую гипотезу] holds up.

Interview:
[Выберите один из вариантов уровня]:
- Вариант А (знаю данные и статистику): Assume I am a Senior Data Scientist familiar with this domain: skip basic explanations, focus on statistical rigor, edge cases, and exact numbers.
- Вариант Б (новый незнакомый домен / нужен взгляд со стороны): Assume I am unfamiliar with the nuances of these data/domain: explain your reasoning clearly at each step and flag non-obvious domain pitfalls.

Before writing any analysis code, interview me: ask clarifying questions about the domain, constraints, and goals so we can reason through this problem together.
Work with me in a step-wise manner and wait for my confirmation before executing each step.

Task:
Answer the following key questions:
1. [Ключевой бизнес- или исследовательский вопрос 1]
2. [Ключевой вопрос 2]
3. [Опционально: какое решение мы должны принять по итогам]

First, give me a high-level design of the analysis (plan-jupyter: chapters, key hypotheses, statistical checks, and potential pitfalls) that will help us answer these questions given the data and background context above. Keep the process high level at first, tell me what you are thinking before each step, and ask any follow-on questions as needed.

Data source:
The data is located at [Укажите путь к файлу, таблице или команду загрузки, например: data/raw.parquet или sns.load_dataset("penguins")].
[Выберите один из вариантов знания схемы]:
- Вариант А (схема неизвестна): I'm not sure about the exact schema or data quality yet — start by inspecting the data structure, missing values, and potential biases before jumping to conclusions.
- Вариант Б (схема известна): I know the schema well ([кратко опишите ключевые колонки / ключи или сошлитесь на файл схемы/документацию]), so skip exploratory guesswork — just run a quick sanity check on this fresh extract (row counts, date range, nulls, duplicates, unexpected values) before proceeding.
```

### Разбор стартового промпта: почему он работает

Промпт собран по фреймворку **CRIT** (Context, Role, Interview, Task), и в каждом его блоке зашит конкретный приём против типичных ошибок LLM:

* **Context (защита от поддакивания).**
  Фраза *«Everyone in the room was skeptical. We need hard data to prove it»* сразу отключает у модели режим «согласиться с пользователем» и настраивает её искать дыры в гипотезе (смещение выборки, конфаундеры, корреляция вместо причинности), а не подтверждать исходное утверждение.

* **Role (доменные эвристики).**
  Указана не просто роль «data scientist», а узкий профиль (*marketing analytics, 10 years in retail*) + *«using your intuition and experience»*. Это подтягивает специфичные для домена проверки (атрибуция, сезонность, офлайн vs онлайн), которые модель иначе могла бы пропустить.

* **Interview (главная фишка промпта).**
  * *«Work with me in a step-wise manner. Let’s look at each step together»* — стоп-кран, который не даёт агенту молча написать 15 ячеек кода за один проход и нагаллюцинировать выводы.
  * *«I want YOU to ask me questions»* — переворачивает стандартное поведение LLM: вместо того чтобы додумывать бизнес-контекст, агент обязан сначала вытащить его из вас.
  * *Уровень объяснений* — явно задаёт глубину: для рабочего анализа указываем реальную роль **Senior DS** (максимум статистической строгости), а переключать тон на нетехнический (CEO / PM) имеет смысл только в самом конце, когда выводы уже проверены и их нужно переупаковать для бизнеса.

* **Task (связка решения и данных).**
  * Сначала идут **бизнес-вопросы** (*should we invest? how much?*), а не техническое «построй график» — это задаёт агенту конечную цель.
  * *«Tell me what you are thinking at each step»* — заставляет проговаривать логику до запуска кода.
  * *Указание на схему* — либо честно говорит, что схема неизвестна (агент обязан начать с `df.info()` / `df.head()`), либо задаёт схему, но оставляет обязательный sanity check свежей выгрузки.

### Усиления из второго кейса (эксперимент со станками)

* **Протокол эксперимента / сбора данных в `Context`.** Краткий список того, *как* появились данные (например, кто и сколько работал, как распределяли группы), позволяет агенту сразу вскрыть методологические дыры: смешение факторов (конфаундеры вроде «1 оператор = 1 станок») и временной дрейф (усталость, эффект обучения).
* **Явное право «забраковать» саму задачу в `Role`.** Формулировка *«help us make this decision — or show us what we should be thinking about or doing wrong»* сильнее обычного скепсиса: она разрешает агенту не натягивать «победителя» из таблицы, а прямо сказать, что эксперимент сломан и решение принимать рано.
* **Запрос плана анализа до кода в `Task`.** Фраза *«give me a high-level design of the analysis... Keep the process high level»* формализует шаг `plan-jupyter`: сначала согласуем верхнеуровневый дизайн анализа, и только потом переходим к коду.

### Что выносится за рамки промпта (в `SKILL.md`)

Всё повторяющееся и техническое (FWER, `ai_viz.py`, нумерация глав, `uv`, pre-commit, формат выводов) не нужно дублировать в каждом CRIT-промпте — эти правила выносятся в отдельный скилл (`SKILL.md` + `references/`, на базе структуры из репозитория Роберто Родригеса), чтобы сам промпт оставался коротким и содержал только суть конкретной задачи.

## Шаг 2: Итерация / Follow-up — вброс внешнего контекста

### Пример из вебинара DataCamp

После того как агент проверил таблицу кодом и задал уточняющие вопросы (в том числе подсветил аномалию `"20-Dec"` в колонке возраста), пользователь вбрасывает «грязную реальность», которой физически нет в данных:

```text
* **my apologies for the data quality issues. I doublechecked and the "20-Dec" data is an anomaly and a data quality issue. My data people are idiots and they didn't load the data correctly.**
  * "20-Dec" should really be "12-20" for the "AgeBracket".
  * Can you do me a favor? It's going to take my data engineers another 6 months on a backlog to fix the data. Can you just assume, for now that `"20-Dec" = 12-20` for the AgeBracket?
* A little more about our business may help you.
  * We are a retailer of **cold weather apparel** sold to mostly to the **Under 40** demographic.
  * we are omni-channel but only about 20% of our receipts are from our shopping mall stores.

I also just confirmed some things with the CMO about HOW her team conducted the interviews. Here's the key findings:
* the surveys were only taken at one mall location in California.
* the surveys were conducted **as the shoppers where leaving the store**
* in many cases the respondents would not give their actual age ranges and the folks conducting the surveys guessed at their age ranges.
* the survey looked like this:

Store Survey
1. Did you hear about us through social media? Yes/No
2. If you answered "yes", which social media website?

With this new information, can you provide any additional insights?
```

### Почему этот шаг критичен (разбор)

Никакой `pandas` и никакой код не смогли бы достать эти факты из самой таблицы, но они полностью меняют выводы анализа:

* **Исправление бага данных «на лету»:** `"20-Dec"` в `AgeBracket` — классический баг автоформатирования Excel. Пользователь явно разрешает агенту заложить временный маппинг в код, не дожидаясь дата-инженеров.
* **Географическое и канальное смещение:** бренд продаёт *зимнюю одежду*, но опрос проходил в *одном ТЦ в Калифорнии*, а сами магазины в ТЦ дают лишь *20% выручки*.
* **Ошибка выжившего (Exit bias):** опрашивали только тех, кто *выходил из магазина* — онлайн-покупатели и те, кто не зашёл, не попали в выборку.
* **Шум в измерениях:** интервьюеры *угадывали возраст на глаз*, значит сегментации по возрасту доверять нельзя.
* **Сломанный дизайн анкеты:** опрос спрашивал *только* про соцсети, полностью игнорируя поиск, рекомендации, рассылки и другие каналы.

### Где отвечать на вопросы агента

Рабочие оба варианта — выбирайте по ситуации:

1. **В чате (обычно удобнее):** отвечаете прямо в диалоге, а в конце просите агента перенести принятые допущения в Markdown-ячейку ноутбука (эта строка уже есть в шаблоне ниже).
2. **Прямо в Markdown-ячейке ноутбука:** вписываете ответы под вопросами, сохраняете файл и пишете агенту в чат: *«Я ответил в ячейке X, пересчитай анализ с учётом этих вводных»*.

### Драфт follow-up промпта (шаблон для ответов агенту)

Используйте этот шаблон на следующих итерациях, когда отвечаете на вопросы агента после первичного осмотра данных:

```text
Here are the clarifications based on your questions and initial data inspection:

1. Data quality & temporary fixes:
- [Опишите найденную аномалию, например: значение "X" в колонке "Y" — это баг выгрузки].
- For this analysis, please assume/remap: [Укажите временное правило очистки или фильтрации в коде].

2. Business & domain context (not in the table):
- [Ключевые факты о продукте, аудитории, доле каналов или сезонности].

3. Data collection & potential biases:
- How the data was collected: [Кто, где, когда и как собирал данные / логи].
- Known limitations / noise: [Пропуски, ручной ввод, угадывание, смещение выборки].

Please document these assumptions in a Markdown cell in the notebook, update the analysis/calculations accordingly, and revise your conclusions with these constraints in mind.
```

## Рабочие практики (Workflow & Hygiene)

### Петля агентного EDA

Вся сила агентного анализа — не в одном «идеальном» промпте, а в короткой итеративной петле:

1. Агент проверяет данные кодом и подсвечивает аномалии / дыры в схеме.
2. Вы докидываете внешний контекст (как собирались данные, какие есть перекосы, какие временные фиксы допустимы в коде).
3. Агент пересчитывает метрики и корректирует выводы с учётом этих ограничений.

### Фиксация контекста прямо в блокноте

Уточнения, временные маппинги (вроде `"20-Dec" -> "12-20"`) и ограничения выборки полезно фиксировать **прямо в Markdown-ячейках ноутбука**, а не оставлять только в чате. Тогда при повторном открытии файла или в новой сессии с агентом весь бизнес-контекст и история решений остаются на виду.

### Когда подключать скилл `graphify`

`graphify` строит граф знаний по репозиторию, чтобы агент сразу видел архитектуру и связи между файлами, не тратя токены на слепой поиск.

* **Когда стоит использовать:** в средних и крупных проектах (ориентир — **от 10–15 связанных файлов/таблиц**: SQL/dbt-модели, ETL-скрипты, конфиги, внутренние модули и документация).
* **Когда избыточен:** в ad-hoc анализе на 1–3 таблицах и одном ноутбуке — проще сразу дать пути к файлам.
* **Важное ограничение:** `graphify` знает только **статику** (код, схемы, зависимости), но не видит **живые значения** в конкретной выгрузке (аномалии вроде `"20-Dec"`, внезапный всплеск `NaN` или смещение распределения). Поэтому в большом проекте лучшая связка: `graphify` для понимания архитектуры + код для sanity check живых данных.

### Гигиена синхронизации файлов (чтобы не терять правки)

Если агент правит `.ipynb` / `.py` напрямую на диске, главное правило одно — **не редактировать активный файл, пока агент генерирует и записывает изменения** (скроллить, читать и переключаться на другие файлы можно).

Выбор режима сохранения в VS Code:

* **`Auto Save: onFocusChange` (золотая середина):** файл автоматически сохраняется ровно в тот момент, когда вы переключаете фокус из редактора в окно чата агента. Не нужно помнить про `Ctrl+S`, а случайные нажатия в чате не затронут файл.
* **`Auto Save: off` + ручной `Ctrl+S` перед промптом (максимальный контроль):** защищает от случайных опечаток при чтении файла, но требует железной привычки сохраняться до отправки задачи агенту.
* **`Auto Save: afterDelay`:** удобно для скорости, но выше риск случайно сохранить опечатку, если задеть клавиатуру во время работы агента.
* **Для настоящей одновременной работы в одном блокноте:** используйте связку **JupyterLab + `jupyter-collaboration` + `jupyter-mcp-server`** — синхронизация идёт в реальном времени через CRDT на уровне одного сервера без конфликтов сохранения на диск.

## Источники

* **Фреймворк CRIT:** Geoff Woods, *The AI-Driven Leader*.
* **Адаптация под Data Science и примеры промптов:** вебинар DataCamp *«How to Do Agentic Data Analysis»*.
* **Архитектура Skills (`SKILL.md` + `references/`):** доклад и репозиторий Roberto Rodriguez (NDC).
