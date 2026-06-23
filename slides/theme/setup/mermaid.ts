import { defineMermaidSetup } from '@slidev/types'

export default defineMermaidSetup(() => {
  return {
    theme: 'base',
    themeCSS: `
    .neoblock > rect {
      stroke: #000 !important;
      stroke-width: 2px !important;
      filter: drop-shadow(4px 4px 0px #000) !important;
    }
    .edgeLabel > p {
      padding: 4px 8px;
      background-color: #F9F5F2 !important;
    }
    `
  }
})