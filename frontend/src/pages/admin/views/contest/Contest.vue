<template>
  <div class="view">
    <Panel :title="title">
      <b-row>
        <b-col cols="12">
          <b-form-group
            label-for="ContestTitle"
          >
            <template #label>
              <p class="labels">
                <span class="text-danger">*</span>
                Title
              </p>
            </template>
            <b-form-input
              id="ContestTitle"
              v-model="contest.title"
              placeholder="Title"
            />
          </b-form-group>
        </b-col>
        <b-col cols="12">
          <p class="labels">
            <span class="text-danger">*</span>
            Description
          </p>
          <tiptap v-model="contest.description"/>
        </b-col>
        <b-col cols="4">
          <b-form-group label-for="Contest_Start_Time">
            <template #label>
              <p class="labels" style="margin-top:16px">
                <span class="text-danger">*</span>
                Start Time
              </p>
            </template>
            <b-form-datepicker
              id="Contest_Start_Time"
              v-model="startDate"
              today-button
              close-button
              type="datetime"
              :date-format-options="{ year: 'numeric', month: '2-digit', day: '2-digit' }"
              locale="en"
              placeholder="Start Time"
              style = "margin-bottom:10px"
            />
            <b-form-timepicker
              v-model="startTime"
              show-seconds
              now-button
            >
            </b-form-timepicker>
          </b-form-group>
        </b-col>
        <b-col cols="4">
          <b-form-group label-for="Contest_End_Time">
            <template #label>
              <p class="labels" style="margin-top:16px">
                <span class="text-danger">*</span>
                End Time
              </p>
            </template>
            <b-form-datepicker
              id="Contest_End_Time"
              v-model="endDate"
              today-button
              close-button
              type="datetime"
              :date-format-options="{ year: 'numeric', month: '2-digit', day: '2-digit' }"
              locale="en"
              placeholder="End Time"
              style="margin-bottom:10px"
            />
            <b-form-timepicker
              v-model="endTime"
              show-seconds
              now-button
            >
            </b-form-timepicker>
          </b-form-group>
        </b-col>
        <b-col cols="4">
          <b-form-group label-for="Contest_Password">
            <template #label>
              <p class="labels" style="margin-top:16px">
                Password
              </p>
            </template>
            <b-input
              v-model="contest.password"
              placeholder="Password"
            />
          </b-form-group>
        </b-col>
        <!-- <b-col :span="8">
              <b-form-group :label="$t('m.Contest_Rule_Type')">
              <b-button v-model="contest.rule_type" label="ACM" :disabled="disableRuleType">ACM</b-radio>
              <b-button v-model="contest.rule_type" label="OI" :disabled="disableRuleType">OI</b-radio>
              </b-form-item>
              </b-col> -->
        <b-col cols="4">
          <b-form-group>
            <template #label>
              <p class="labels">
                Real Time Rank
              </p>
            </template>
            <b-form-checkbox v-model="contest.real_time_rank" switch>
            </b-form-checkbox>
          </b-form-group>
        </b-col>
        <b-col cols="8">
          <b-form-group>
            <template #label>
              <p class="labels">
                Status
              </p>
            </template>
            <b-form-checkbox v-model="contest.visible" switch>
            </b-form-checkbox>
          </b-form-group>
        </b-col>
        <b-col>
          <b-form-group>
            <template #label>
              <p class="labels">
                Allowed IP Ranges
              </p>
            </template>
            <div
              v-for="(range, index) in contest.allowed_ip_ranges"
              :key="index"
            >
              <b-row style="margin-bottom: 15px">
                <b-col cols="4">
                  <b-form-input
                    v-model="range.value"
                    placeholder="CIDR Network"
                  />
                </b-col>
                <b-col cols="1">
                  <b-button @click="addIPRange" variant="outline-secondary">
                      <b-icon icon="plus"></b-icon>
                  </b-button>
                </b-col>
                <b-col cols="1">
                  <b-button @click="removeIPRange(range)" variant="outline-secondary">
                      <b-icon icon="trash-fill"></b-icon>
                  </b-button>
                </b-col>
              </b-row>
            </div>
          </b-form-group>
        </b-col>
      </b-row>
      <save @click.native="saveContest" />
    </Panel>
  </div>
</template>

<script>
import api from '../../api.js'
import Tiptap from '../../components/Tiptap.vue'

export default {
  name: 'CreateContest',
  components: {
    Tiptap
  },
  data () {
    return {
      title: 'Create Contest',
      disableRuleType: false,
      contest: {
        title: '',
        description: '',
        start_time: '',
        end_time: '',
        rule_type: 'ACM',
        password: '',
        real_time_rank: true,
        visible: true,
        allowed_ip_ranges: [{
          value: ''
        }]
      },
      startTime: '',
      startDate: '',
      endTime: '',
      endDate: ''
    }
  },
  mounted () {
    if (this.$route.name === 'edit-contest') {
      this.title = 'Edit Contest'
      this.disableRuleType = true
      api.getContest(this.$route.params.contestId).then(res => {
        const data = res.data.data
        const ranges = []
        for (const v of data.allowed_ip_ranges) {
          ranges.push({ value: v })
        }
        if (ranges.length === 0) {
          ranges.push({ value: '' })
        }
        data.allowed_ip_ranges = ranges
        this.contest = data
        this.initTime()
      }).catch(() => {
      })
    }
  },
  methods: {
    saveContest () {
      this.setStartTime()
      this.setEndTime()
      const funcName = this.$route.name === 'edit-contest' ? 'editContest' : 'createContest'
      const data = Object.assign({}, this.contest)
      const ranges = []
      for (const v of data.allowed_ip_ranges) {
        if (v.value !== '') {
          ranges.push(v.value)
        }
      }
      data.allowed_ip_ranges = ranges
      api[funcName](data).then(res => {
        this.$router.push({ name: 'contest-list', query: { refresh: 'true' } })
      }).catch(() => {
      })
    },
    initTime () {
      ;[this.startDate, this.startTime] = this.contest.start_time.split(/T|[+]/)
      ;[this.endDate, this.endTime] = this.contest.end_time.split(/T|[+]/)
    },
    setStartTime () {
      this.contest.start_time = this.startDate + ' ' + this.startTime
    },
    setEndTime () {
      this.contest.end_time = this.endDate + ' ' + this.endTime
    },
    addIPRange () {
      this.contest.allowed_ip_ranges.push({ value: '' })
    },
    removeIPRange (range) {
      const index = this.contest.allowed_ip_ranges.indexOf(range)
      if (index !== -1) {
        this.contest.allowed_ip_ranges.splice(index, 1)
      }
    }
  }
}
</script>

<style scoped>
  .row, .col {
    word-wrap: break-word;
  }
</style>
