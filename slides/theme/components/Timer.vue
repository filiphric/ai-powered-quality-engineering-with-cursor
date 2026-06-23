<template>
  <div class="timer-container relative block group justify-self-center">
    <!-- Up arrow (visible on hover) -->
    <button
      @click="increaseTime"
      class="absolute -top-5 left-1/2 transform -translate-x-1/2 w-6 h-6 flex items-center justify-center transition-all duration-200 opacity-0 group-hover:opacity-100 z-10"
    >
      <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 15l7-7 7 7"></path>
      </svg>
    </button>

    <!-- Timer display -->
    <div class="bg-[#00B6B1] py-3 border-2 border-black custom-block font-extrabold flex items-center justify-center space-x-2 w-[330px]">
        <span class="text-4xl font-medium text-gray-800 min-w-[80px] text-center">
          {{ displayTime }}
        </span>
        
        <!-- Play/Stop button -->
        <button
          @click="toggleTimer"
          class="w-8 h-8 rounded-full flex items-center justify-center transition-colors duration-200 bg-white hover:bg-gray-100 border-2 border-black"
        >
          <svg v-if="!isRunning" class="w-4 h-4" fill="currentColor" viewBox="0 0 24 24">
            <path d="M8 5v14l11-7z"/>
          </svg>
          <svg v-else class="w-4 h-4" fill="currentColor" viewBox="0 0 24 24">
            <path d="M6 19h4V5H6v14zm8-14v14h4V5h-4z"/>
          </svg>
        </button>
      </div>

    <!-- Down arrow (visible on hover) -->
    <button
      @click="decreaseTime"
      class="absolute -bottom-6 left-1/2 transform -translate-x-1/2 w-6 h-6 flex items-center justify-center transition-all duration-200 opacity-0 group-hover:opacity-100 z-10"
      :disabled="timeInMinutes <= 1"
    >
      <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"></path>
      </svg>
    </button>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onUnmounted } from 'vue'

// State
const timeInMinutes = ref(20)
const isRunning = ref(false)
const intervalId = ref<number | null>(null)
const remainingSeconds = ref(0)

// Computed
const displayTime = computed(() => {
  if (isRunning.value) {
    const minutes = Math.floor(remainingSeconds.value / 60)
    const seconds = remainingSeconds.value % 60
    return `${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`
  }
  return `${timeInMinutes.value} minutes`
})

// Methods
const increaseTime = () => {
  if (timeInMinutes.value < 120) { // Max 2 hours
    timeInMinutes.value += 1
  }
}

const decreaseTime = () => {
  if (timeInMinutes.value > 1) {
    timeInMinutes.value -= 1
  }
}

const startTimer = () => {
  remainingSeconds.value = timeInMinutes.value * 60
  isRunning.value = true
  
  intervalId.value = window.setInterval(() => {
    remainingSeconds.value--
    
    if (remainingSeconds.value <= 0) {
      stopTimer()
      // Optional: Add notification sound or alert
    }
  }, 1000)
}

const stopTimer = () => {
  if (intervalId.value) {
    clearInterval(intervalId.value)
    intervalId.value = null
  }
  isRunning.value = false
  remainingSeconds.value = 0
}

const toggleTimer = () => {
  if (isRunning.value) {
    stopTimer()
  } else {
    startTimer()
  }
}

// Cleanup
onUnmounted(() => {
  if (intervalId.value) {
    clearInterval(intervalId.value)
  }
})
</script>

<style scoped>
/* Smooth transitions for arrows */
.timer-container button {
  transition: opacity 0.2s ease-in-out;
}

.custom-block {
  box-shadow: 4px 4px 0 0 black;
  display: flex;
}
</style>