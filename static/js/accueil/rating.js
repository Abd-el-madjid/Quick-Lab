/* 

	Awesome open-source libraries used here:
	* sweetalert2 / sweetalert2  (https://sweetalert2.github.io/)
	* catdad / canvas-confetti (https://github.com/catdad/canvas-confetti)
	* fontawesome icons(https://fontawesome.com/) 

	Check pen settings for CDN links. Enjoy!!!
	
*/

// ===================================
// interactive elements
const stars = document.getElementsByClassName("fa-star");
const joinTag = document.getElementById("join");
const closeBtn = document.getElementById("close");
const homeBtn = document.getElementById("return");

// ===================================
// functions and procedures
const resetStars = (stars) => {
	for (let i = 0; i < stars.length; i++) {
		stars[i].classList.remove("fas");
		stars[i].classList.add("far");
	}
};

const fillStars = (event) => {
	const { id } = event.target;

	const mapper = {
		one: 1,
		two: 2,
		three: 3,
		four: 4,
		five: 5
	};
	const id2num = mapper[id];

	for (let i = 0; i < id2num; i++) {
		stars[i].classList.remove("far");
		stars[i].classList.add("fas");
	}
};

// ===================================
// handlers
const handleStarClickEvent = (event) => {
	resetStars(stars);
	fillStars(event);
};

const handleJoinTagClickEvent = (event) => {
	Swal.fire({
		title: "Awesome!",
		text: "Going back to the meeting",
		iconHtml: '<i class="fas fa-handshake"></i>',
		iconColor: "#FFFFFF",
		background: "linear-gradient(to left, #c3a4f3, #858fe8)",
		confirmButtonText: "Nnneeaoowww!",
		confirmButtonColor: "#6317ae"
	});
};

const handleCloseButtonClickEvent = (event) => {
	Swal.fire({
		title: "Aw, drats!",
		text: "Leaving already?",
		iconHtml: '<i class="fas fa-sad-cry"></i>',
		iconColor: "#FFFFFF",
		background: "linear-gradient(to left, #c3a4f3, #858fe8)",
		confirmButtonText: "Buh-bye!",
		confirmButtonColor: "#6317ae"
	});
};

const handleHomeButtonClickEvent = (event) => {
	// yay confetti!!
	// https://github.com/catdad/canvas-confetti
	confetti();
};

// ===================================
// imperative code - attaching event listeners
for (let idx = 0; idx < stars.length; idx++) {
	stars[idx].addEventListener("click", handleStarClickEvent);
}
joinTag.addEventListener("click", handleJoinTagClickEvent);
closeBtn.addEventListener("click", handleCloseButtonClickEvent);
homeBtn.addEventListener("click", handleHomeButtonClickEvent);
