<template>
  <div class="error404">
    <div class="error404-body-con">
      <b-card>
        <div class="error404-body-con-title">
          4<span><b-icon icon="arrow-up-right-circle" /></span>4
        </div>
        <p class="error404-body-con-message">
          YOU&nbsp;&nbsp;LOOK&nbsp;&nbsp;LOST
        </p>
        <div class="error404-btn-con">
          <b-button
            class="btn-gohome"
            size="lg"
            style="width: 200px;"
            @click="goHome"
          >
            {{ $t('m.Go_Home') }}
          </b-button>
          <b-button
            class="btn-backpage"
            size="lg"
            style="width: 200px;margin-left: 40px;"
            @click="backPage"
          >
            {{ $t('m.Back') }}
          </b-button>
        </div>
      </b-card>
    </div>
  </div>
</template>

<script>
export default {
  name: 'Error404',
  methods: {
    backPage () {
      this.$router.go(-1)
    },
    goHome () {
      this.$router.push({
        name: 'home'
      })
    }
  }
}
</script>

<style lang="scss" scoped>
  @keyframes error404animation {
    0% {
      transform: rotateZ(0deg);
    }
    20% {
      transform: rotateZ(-60deg);
    }
    40% {
      transform: rotateZ(-10deg);
    }
    60% {
      transform: rotateZ(50deg);
    }
    80% {
      transform: rotateZ(-20deg);
    }
    100% {
      transform: rotateZ(0deg);
    }
  }

  .error404 {
    &-body-con {
      width: 700px;
      height: 500px;
      margin: 0 auto;
      &-title {
        text-align: center;
        font-size: 240px;
        font-weight: 700;
        color: #2d8cf0;
        height: 260px;
        line-height: 260px;
        margin-top: 40px;
        span {
          display: inline-block;
          color: #19be6b;
          font-size: 220px;
          animation: error404animation 3s ease 0s infinite alternate;
        }
      }
      &-message {
        display: block;
        text-align: center;
        font-size: 30px;
        font-weight: 500;
        letter-spacing: 12px;
        color: #dddde2;
      }
    }
    &-btn-con {
      text-align: center;
      padding: 20px 0;
      margin-bottom: 40px;
    }
  }

  .btn-gohome {
    color: #727272;
    background-color: #fff;
    border: 1px solid #dddee1;
    &:hover {
      color: #2d8cf0;
      border-color: #2d8cf0;
      background-color: #fff;
    }
    &:active {
      background-color: #fff;
    }
    &:focus {
      color: #2d8cf0;
      border-color: #2d8cf0;
      background-color: #2d8cf0;
    }
  }

  .btn-backpage {
    background-color: #2d8cf0;
    &:hover {
      border-color: #4a9af0;
      background-color: #4a9af0;
    }
    &:active {
      background-color: #4a9af0;
    }
    &:focus {
      border-color: #4a9af0;
      background-color: #4a9af0;
    }
  }
</style>
