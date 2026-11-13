(() => {
  const STORAGE_KEY = "todolist.tasks.v1";
  const STATUSES = ["todo", "doing", "done"];

  let tasks = load();
  let query = "";

  const lists = Object.fromEntries(STATUSES.map(s => [s, document.getElementById("list-" + s)]));
  const counts = Object.fromEntries(STATUSES.map(s => [s, document.getElementById("count-" + s)]));

  // ---------- storage ----------
  function load() {
    try {
      const data = JSON.parse(localStorage.getItem(STORAGE_KEY));
      if (Array.isArray(data)) return data.filter(t => t && STATUSES.includes(t.status));
    } catch (e) { /* ignore */ }
    return [];
  }

  function save() {
    try { localStorage.setItem(STORAGE_KEY, JSON.stringify(tasks)); } catch (e) { /* ignore */ }
  }

  // ---------- actions ----------
  function addTask(title, status) {
    tasks.push({ id: Date.now().toString(36) + Math.random().toString(36).slice(2, 6), title, status });
    commit();
  }

  function moveTask(id, status, beforeId) {
    const i = tasks.findIndex(t => t.id === id);
    if (i === -1) return;
    const [task] = tasks.splice(i, 1);
    task.status = status;
    const j = beforeId ? tasks.findIndex(t => t.id === beforeId) : -1;
    if (j === -1) tasks.push(task); else tasks.splice(j, 0, task);
    commit();
  }

  function renameTask(id, title) {
    const task = tasks.find(t => t.id === id);
    if (task && title.trim()) task.title = title.trim();
    commit();
  }

  function deleteTask(id) {
    tasks = tasks.filter(t => t.id !== id);
    commit();
  }

  function commit() {
    save();
    render();
  }

  // ---------- render ----------
  function render() {
    const q = query.trim().toLowerCase();
    for (const status of STATUSES) {
      const list = lists[status];
      list.replaceChildren();
      const all = tasks.filter(t => t.status === status);
      const shown = q ? all.filter(t => t.title.toLowerCase().includes(q)) : all;
      shown.forEach(t => list.appendChild(card(t)));
      if (!shown.length) {
        const empty = document.createElement("li");
        empty.className = "empty";
        empty.textContent = q ? "No matches" : "Nothing here";
        list.appendChild(empty);
      }
      counts[status].textContent = all.length;
    }
  }

  function card(task) {
    const li = document.createElement("li");
    li.className = "card" + (task.status === "done" ? " done" : "");
    li.draggable = true;
    li.dataset.id = task.id;

    const check = document.createElement("input");
    check.type = "checkbox";
    check.checked = task.status === "done";
    check.setAttribute("aria-label", "Mark done");
    check.addEventListener("change", () => moveTask(task.id, check.checked ? "done" : "todo"));

    const title = document.createElement("span");
    title.className = "title";
    title.textContent = task.title;
    title.title = "Double-click to edit";
    title.addEventListener("dblclick", () => edit(li, task, title));

    const actions = document.createElement("div");
    actions.className = "actions";
    const idx = STATUSES.indexOf(task.status);
    if (idx > 0) actions.appendChild(button("←", "Move left", () => moveTask(task.id, STATUSES[idx - 1])));
    if (idx < STATUSES.length - 1) actions.appendChild(button("→", "Move right", () => moveTask(task.id, STATUSES[idx + 1])));
    actions.appendChild(button("✎", "Edit", () => edit(li, task, title)));
    const del = button("✕", "Delete", () => deleteTask(task.id));
    del.classList.add("delete");
    actions.appendChild(del);

    li.append(check, title, actions);

    li.addEventListener("dragstart", e => {
      e.dataTransfer.setData("text/plain", task.id);
      e.dataTransfer.effectAllowed = "move";
      li.classList.add("dragging");
    });
    li.addEventListener("dragend", () => li.classList.remove("dragging"));
    return li;
  }

  function button(label, aria, onClick) {
    const b = document.createElement("button");
    b.type = "button";
    b.textContent = label;
    b.setAttribute("aria-label", aria);
    b.title = aria;
    b.addEventListener("click", onClick);
    return b;
  }

  function edit(li, task, titleEl) {
    const input = document.createElement("input");
    input.type = "text";
    input.className = "edit";
    input.value = task.title;
    input.maxLength = 200;
    li.draggable = false;
    titleEl.replaceWith(input);
    input.focus();
    input.select();
    let finished = false;
    const finish = ok => {
      if (finished) return;
      finished = true;
      if (ok) renameTask(task.id, input.value); else render();
    };
    input.addEventListener("keydown", e => {
      if (e.key === "Enter") finish(true);
      if (e.key === "Escape") finish(false);
    });
    input.addEventListener("blur", () => finish(true));
  }

  // ---------- events ----------
  document.querySelectorAll(".add-form").forEach(form => {
    form.addEventListener("submit", e => {
      e.preventDefault();
      const input = form.querySelector("input");
      const title = input.value.trim();
      if (!title) return;
      addTask(title, form.dataset.status);
      input.value = "";
      input.focus();
    });
  });

  document.querySelectorAll(".column").forEach(col => {
    const status = col.dataset.status;
    col.addEventListener("dragover", e => {
      e.preventDefault();
      col.classList.add("drag-over");
    });
    col.addEventListener("dragleave", e => {
      if (!col.contains(e.relatedTarget)) col.classList.remove("drag-over");
    });
    col.addEventListener("drop", e => {
      e.preventDefault();
      col.classList.remove("drag-over");
      const id = e.dataTransfer.getData("text/plain");
      const target = e.target.closest(".card");
      moveTask(id, status, target && target.dataset.id !== id ? target.dataset.id : null);
    });
  });

  document.getElementById("search").addEventListener("input", e => {
    query = e.target.value;
    render();
  });

  document.getElementById("clear-done").addEventListener("click", () => {
    tasks = tasks.filter(t => t.status !== "done");
    commit();
  });

  render();
})();
