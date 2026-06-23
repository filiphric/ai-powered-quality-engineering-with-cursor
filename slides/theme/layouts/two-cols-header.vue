<template>
  <div class="slidev-layout two-cols-header w-full h-full">
    <div class="col-header">
      <slot />
    </div>
    <div class="col-left">
      <slot name="left" />
    </div>
    <div class="col-right">
      <slot name="right" />
    </div>
    <div class="col-bottom">
      <slot name="bottom" />
    </div>
  </div>
</template>
