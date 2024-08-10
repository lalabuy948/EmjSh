import confetti from "canvas-confetti";

var scalar = 2;
var unicorn = confetti.shapeFromText({ text: "🦄", scalar });
var tada = confetti.shapeFromText({ text: "🎉", scalar });
var rocket = confetti.shapeFromText({ text: "🚀", scalar });
var coder = confetti.shapeFromText({ text: "👨🏻‍💻", scalar });

export const Confetti = {
  mounted() {
    this.el.addEventListener("click", (e) => {
      confetti({
        particleCount: 100,
        spread: 170,
        origin: { y: 0.6 },
      });
    });
  },
};
