const fallAsleeoTime = new Date();
fallAsleepTime.setMinutes(fallAsleepTime.getMinutes() + 14);
const config = {
    timeStyle: "short"
};
console.log(fallAsleepTime.toLocaleTimeString("en-US", config));

const wakeUpTime = new Date(fallAsleepTime);
const wakeUpTimes = [];
for (let i = 1; i <= 6; i++) {
    wakeUpTime.setMinutes(wakeUPTime.getMinutes() + 90);
    const wakeUpTimeString = wakeUpTime.toLocaleTimeString("en-US", config);
    wakeUpTimes.push(wakeUpTimeString);
}

console.log('Wake up times are:' , wakeUpTimes);