<div align="center">
  <a href="{{ link.home }}" title="{{ organization }} homepage" target="_blank">
    <img alt="Homepage" src="https://img.shields.io/website?down_color=%23FF4136&down_message=Down&label=Homepage&logo=home-assistant&logoColor=white&up_color=%232ECC40&up_message=Up&url=https%3A%2F%2Fmegabyte.space&style={{ badge_style }}" />
  </a>
  <a href="{{ repository.github }}{{ repository.location.contributing.github }}" title="Learn about contributing" target="_blank">
    <img alt="Contributing" src="https://img.shields.io/badge/Contributing-Guide-0074D9?logo=github-sponsors&logoColor=white&style={{ badge_style }}" />
  </a>
  <a href="{{ link.chat }}" title="Chat with us on Slack" target="_blank">
    <img alt="Slack" src="https://img.shields.io/badge/Slack-Chat-e01e5a?logo=slack&logoColor=white&style={{ badge_style }}" />
  </a>
  <a href="{{ link.gitter }}" title="Chat with the community on Gitter" target="_blank">
    <img alt="Gitter" src="https://img.shields.io/gitter/room/megabyte-labs/community?logo=gitter&logoColor=white&style={{ badge_style }}" />
  </a>
  <a href="{{ repository.github }}" title="GitHub mirror" target="_blank">
    <img alt="GitHub" src="https://img.shields.io/badge/Mirror-GitHub-333333?logo=github&style={{ badge_style }}" />
  </a>
  <a href="{{ repository.gitlab }}" title="GitLab repository" target="_blank">
    <img alt="GitLab" src="https://img.shields.io/badge/Repo-GitLab-fc6d26?logo=data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgAQMAAABJtOi3AAAABlBMVEUAAAD///+l2Z/dAAAAAXRSTlMAQObYZgAAAHJJREFUCNdNxKENwzAQQNEfWU1ZPUF1cxR5lYxQqQMkLEsUdIxCM7PMkMgLGB6wopxkYvAeI0xdHkqXgCLL0Beiqy2CmUIdeYs+WioqVF9C6/RlZvblRNZD8etRuKe843KKkBPw2azX13r+rdvPctEaFi4NVzAN2FhJMQAAAABJRU5ErkJggg==&style={{ badge_style }}" />
  </a>
</div>
<br/>
<div align="center">
  <a href="https://www.npmjs.com/package/{{ pkg.name }}" title="Version {{ pkg.version }}" target="_blank">
    <img alt="Version: {{ pkg.version }}" src="https://img.shields.io/badge/version-{{ pkg.version }}-blue.svg?cacheSeconds=2592000&logo=data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgAQMAAABJtOi3AAAABlBMVEUAAAD///+l2Z/dAAAAAXRSTlMAQObYZgAAACNJREFUCNdjIACY//+BEp9hhM3hAzYQwoBIAqEDYQrCZLwAAGlFKxU1nF9cAAAAAElFTkSuQmCC&style={{ alt_badge_style }}" />
  </a>
  <a href="{{ repository.gitlab }}{{ repository.location.commits.gitlab }}" title="GitLab CI build status" target="_blank">
    <img alt="Build status" src="https://img.shields.io/gitlab/pipeline-status/{{ repository.group.npm_path }}/{{ subgroup }}/{{ slug }}?branch=master&label=build&logo=gitlab&logoColor=white&style={{ alt_badge_style }}">
  </a>
  <a href="https://www.npmjs.com/package/{{ pkg.name }}" title="Dependency status reported by Depfu" target="_blank">
    <img alt="Dependency status reported by Depfu" src="https://img.shields.io/depfu/megabyte-labs/{{ customPackageName }}?logo=codeforces&logoColor=white&style={{ alt_badge_style }}&logo=npm" />
  </a>
  <a href="https://www.npmjs.com/package/{{ pkg.name }}" title="Zip file size" target="_blank">
    <img alt="Zip file size" src="https://img.shields.io/bundlephobia/minzip/{{ pkg.name }}?style={{ alt_badge_style }}&logo=npm&logoColor=white" />
  </a>
  <a href="https://www.npmjs.com/package/{{ pkg.name }}" title="Total downloads of {{ pkg.name }} on npmjs.org" target="_blank">
    <img alt="Total downloads of {{ pkg.name }} on npmjs.org" src="https://img.shields.io/npm/dt/{{ pkg.name }}?style={{ alt_badge_style }}&logo=npm&logoColor=white" />
  </a>
  <a href="https://snyk.io/advisor/npm-package/{{ pkg.name }}" title="Number of vulnerabilities from Snyk scan on {{ pkg.name }}" target="_blank">
    <img alt="Number of vulnerabilities from Snyk scan on {{ pkg.name }}" src="https://img.shields.io/snyk/vulnerabilities/npm/{{ pkg.name }}?style={{ alt_badge_style }}&logo=snyk&logoColor=white" />
  </a>
  <a href="{{ website.documentation }}/{{ group }}" target="_blank">
    <img alt="Documentation" src="https://img.shields.io/badge/documentation-yes-brightgreen.svg?logo=readthedocs&logoColor=white&style={{ alt_badge_style }}" />
  </a>
  <a href="{{ repository.github }}{{ repository.location.license.github }}" target="_blank">
    <img alt="License: {{ license }}" src="https://img.shields.io/badge/license-{{ license }}-yellow.svg?logo=data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgAQMAAABJtOi3AAAABlBMVEUAAAD///+l2Z/dAAAAAXRSTlMAQObYZgAAAHpJREFUCNdjYOD/wMDAUP+PgYHxhzwDA/MB5gMM7AwMDxj4GBgKGGQYGCyAEEgbMDDwAAWAwmk8958xpIOI5zKH2RmOyhxmZjguAiKmgIgtQOIYmFgCIp4AlaQ9OczGkJYCJEAGgI0CGwo2HmwR2Eqw5SBnNIAdBHYaAJb6KLM15W/CAAAAAElFTkSuQmCC&style={{ alt_badge_style }}" />
  </a>
</div>
