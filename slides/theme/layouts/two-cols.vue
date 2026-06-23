<template>
  <div class="slidev-layout two-cols w-full h-full grid grid-cols-2">
    <div class="col-left">
      <slot />
    </div>
    <div class="col-right">
      <slot name="right" />
    </div>
  </div>
</template>