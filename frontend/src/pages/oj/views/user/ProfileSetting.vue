<template>
  <div class="container">
    <div class="setting-main font-bold">
      <div class="section-title logo-title font-bold">
        <h2>Setting</h2>
      </div>
      <div style="display:flex; flex-direction:row; margin-bottom:12px;" class="profileSetting">
        <b-form>
          <h4 class="columnName font-bold">Preferred Language</h4>
            <b-row class="mb-4">
            <b-form-select class="setting-select" v-model="formProfile.language" :options="languages" :selected="formProfile.language"></b-form-select>
            </b-row>
            <b-row class="mb-4">
              <b-button class="setting-btn" variant="success" @click="updateLanguage">
                <b-spinner v-if="loading.btnLanguage" small></b-spinner> Change Language
              </b-button>
            </b-row>
        </b-form>
        <b-form>
          <h4 class="columnName font-bold">Major</h4>
            <b-row class="mb-4">
            <b-form-select class="setting-select" v-model="formProfile.major" :options="majors" :selected="formProfile.major"></b-form-select>
            </b-row>
            <b-row>
              <b-button class="setting-btn" variant="success" @click="updateMajor">
                <b-spinner v-if="loading.btnMajor" small></b-spinner> Change Major
              </b-button>
            </b-row>
        </b-form>
      </div>
      <div style="display:flex; flex-direction:row;" class="accountSetting">
        <b-form>
          <h4 class="columnName font-bold">Change Password</h4>
          <b-form-group class="setting-label" label= "Current Password" prop="old_password">
            <b-form-input class="setting-input" type="password" v-model="formPassword.old_password" required></b-form-input>
          </b-form-group>
          <b-form-group class="setting-label" label="New Password" prop="new_password">
            <b-form-input class="setting-input" type="password" v-model="formPassword.new_password" required></b-form-input>
          </b-form-group>
          <b-form-group class="setting-label" label="Confirm New Password" prop="again_password">
            <b-form-input class="setting-input" type="password" v-model="formPassword.again_password" required></b-form-input>
          </b-form-group>
          <b-button class="setting-btn" variant="success" @click="changePassword">
            <b-spinner v-if="loading.btnPassword" small></b-spinner> Change Password
          </b-button>
        </b-form>
        <b-form>
          <h4 class="columnName font-bold">Change Email</h4>
          <b-form-group class="setting-label" label="Old Email" >
            <b-form-input class="setting-input" v-model="formEmail.old_email" disabled></b-form-input>
          </b-form-group>
          <b-form-group class="setting-label" label="New Email" prop="new_email">
            <b-form-input class="setting-input" type="email" v-model="formEmail.new_email"></b-form-input>
          </b-form-group>
          <b-form-group class="setting-label" label="Current Password" prop="password">
            <b-form-input class="setting-input" type="password" v-model="formEmail.password"></b-form-input>
          </b-form-group>
          <b-button class="setting-btn" variant="success" @click="changeEmail">
            <b-spinner v-if="loading.btnEmail" small></b-spinner> Change Email
          </b-button>
        </b-form>
      </div>
    </div>
  </div>
</template>

<script>
import api from '@oj/api'
import utils from '@/utils/utils'
import { types } from '@/store'

export default {
  name: 'ProfileSetting',
  data () {
    return {
      loading: {
        btnPassword: false,
        btnEmail: false,
        btnLanguage: false,
        btnMajor: false
      },
      loadingSaveBtn: false,
      loadingUploadBtn: false,
      uploadModalVisible: false,
      preview: {},
      uploadImgSrc: '',
      formProfile: {
        language: '',
        major: null,
        semester: null
      },
      languages: [
        { value: null, text: 'Preferred Language' },
        { value: 'C', text: 'C' },
        { value: 'C++', text: 'C++' },
        { value: 'Golang', text: 'Golang' },
        { value: 'Java', text: 'JAVA' },
        { value: 'Python2', text: 'Python2' },
        { value: 'Python3', text: 'Python3' }
      ],
      majors: [
        { value: 'Major(원전공)', text: 'Major(원전공)' },
        { value: 'Double Major(복수전공)', text: 'Double Major(복수전공)' },
        { value: 'Non-CS Major(비전공)', text: 'Non-CS Major(비전공)' }
      ],
      semesters: [
        { value: null, text: 'Semesters' },
        { value: 1, text: '1~2' },
        { value: 2, text: '3~4' },
        { value: 3, text: '5~6' },
        { value: 4, text: '7+' }
      ],
      formPassword: {
        old_password: '',
        new_password: '',
        again_password: ''
      },
      visible: {
        passwordAlert: false,
        emailAlert: false
      },
      formEmail: {
        password: '',
        old_email: '',
        new_email: ''
      }
    }
  },
  mounted () {
    const profile = this.$store.state.user.profile
    Object.keys(this.formProfile).forEach(element => {
      if (profile[element] !== undefined) {
        this.formProfile[element] = profile[element]
      }
    })
    const user = this.$store.getters.user
    api.getUser(user.username).then(res => {
      this.formProfile.major = res.data.data.major
      this.formEmail.old_email = res.data.data.email
    })
    api.getUserInfo(user.username).then(res => {
      this.formProfile.language = res.data.data.language
    })
  },
  methods: {
    updateLanguage () {
      this.loading.btnLanguage = true
      const updateData = utils.filterEmptyValue(Object.assign({}, this.formProfile))
      api.updateProfile(updateData).then(res => {
        this.$success('Success')
        this.$store.commit(types.CHANGE_PROFILE, { profile: res.data.data })
        this.loading.btnLanguage = false
      }, _ => {
        this.loading.btnLanguage = false
      })
    },
    updateMajor () {
      this.loading.btnMajor = true
      const major = {
        major: this.formProfile.major
      }
      api.updateUser(major).then(res => {
        this.$success('Success')
        this.loading.btnMajor = false
      }, _ => {
        this.loading.btnMajor = false
      })
    },
    changePassword () {
      this.loading.btnPassword = true
      const data = Object.assign({}, this.formPassword)
      if (data.again_password !== data.new_password) {
        this.loading.btnPassword = false
        return this.$error('New password does not match')
      }
      if (data.old_password === data.new_password) {
        this.loading.btnPassword = false
        return this.$error('New password doesn\'t change')
      }
      delete data.again_password
      api.changePassword(data).then(res => {
        this.loading.btnPassword = false
        this.visible.passwordAlert = true
        this.$success('Updated password successfully.\nPlease login with new password.', 2500)
        this.visible.passwordAlert = false
        setTimeout(() => {
          this.$bvModal.hide('setting')
          this.$router.push({ name: 'logout' })
        }, 2500)
      }, res => {
        this.loading.btnPassword = false
      })
    },
    changeEmail () {
      this.loading.btnEmail = true
      const data = Object.assign({}, this.formEmail)
      api.changeEmail(data).then(res => {
        this.loading.btnEmail = false
        this.visible.emailAlert = true
        this.$success('Email changed successfully')
        this.formEmail.old_email = this.formEmail.new_email
      }, res => {
        this.loading.btnEmail = false
      })
    }
  },
  computed: {
    previewStyle () {
      return {
        width: this.preview.w + 'px',
        height: this.preview.h + 'px',
        overflow: 'hidden'
      }
    }
  }
}
</script>

<style lang="scss" scoped>
  @font-face {
    font-family: Manrope_bold;
    src: url('../../../../fonts/Manrope-Bold.ttf');
  }
  .container {
    min-width: 800px;
    margin: auto;
    padding: 0;
  }
  .setting-main {
    position: relative;
    margin: 10px 40px;
    padding-bottom: 20px;
    .setting-content {
      margin-left: 20px;
    }
    .mini-container {
      width: 500px;
    }
  }
  .profileSetting {
    display:flex;
    justify-content: space-around;
    margin-bottom:80px;
  }
  .accountSetting {
    display:flex;
    justify-content: space-around;
  }
  .columnName {
    text-align:center;
    margin-bottom:32px;
    color:#808080;
  }
  .logo-title {
    margin:8px 0 16px 0;
    color: #8DC63F;
    text-align:center;
  }
  .font-bold {
    font-family: manrope_bold;
  }
  .setting-label {
    color:#808080;
  }
  .setting-input {
    width:326px;
  }
  .setting-select {
    border-radius: 8px;
    width:326px;
    border:none;
    box-shadow: 0px 2px 8px rgba(0, 0, 0, 0.25);
    color:#828282;
  }
  .setting-btn {
    width:284px;
    display:block;
    margin-left:auto !important;
    margin-right:auto !important;
  }
</style>
