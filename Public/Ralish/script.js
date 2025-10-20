// Show current date on home page
const dateElement = document.getElementById("date");
if (dateElement) {
  const today = new Date();
  dateElement.textContent = `Today is ${today.toLocaleDateString(undefined, {
    weekday: "long",
    year: "numeric",
    month: "long",
    day: "numeric",
  })}`;
}

// Topic selection logic for thoughts page
const topics = {
  life: `
    <h2>Life</h2>
    <p>Life is not about waiting for the storm to pass, but learning to dance in the rain.</p>
    <p>Each moment is a chance to start anew.</p>
  `,
  philosophy: `
    <h2>Philosophy</h2>
    <p>Wisdom begins in wonder. — Socrates</p>
    <p>The unexamined life is not worth living.</p>
  `,
  success: `
    <h2>Success</h2>
    <p>Success is not final; failure is not fatal: it is the courage to continue that counts.</p>
  `,
  happiness: `
    <h2>Happiness</h2>
    <p>Happiness is not something ready made. It comes from your own actions. — Dalai Lama</p>
  `
};

const topicList = document.getElementById("topics");
const contentArea = document.getElementById("content");

if (topicList && contentArea) {
  topicList.addEventListener("click", (e) => {
    const topic = e.target.getAttribute("data-topic");
    if (topic && topics[topic]) {
      contentArea.innerHTML = topics[topic];
    }
  });
}
