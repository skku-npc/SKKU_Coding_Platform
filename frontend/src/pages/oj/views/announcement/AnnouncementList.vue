<template>
    <div class="notice-list-card font-bold">
      <div class="top-bar mb-4">
        <h2 class="title">Notice</h2>
      </div>
      <div class="table">
        <b-table
          hover
          :items="announcements"
          :fields="noticeListColumns"
          :per-page="perPage"
          :current-page="currentPage"
          head-variant="light"
          @row-clicked="goAnnouncement"
        ></b-table>
        <div
          v-if="!announcements.length"
          class="no-announcement"
        >
          <p>No Notice</p>
        </div>
      </div>
      <div class="pagination">
          <b-pagination
            v-model="currentPage"
            :total-rows="rows"
            :per-page="perPage"
            limit="3"
          ></b-pagination>
      </div>
    </div>
</template>

<script>
import api from '@oj/api'
import time from '@/utils/time'
export default {
  name: 'Announcement',
  data () {
    return {
      perPage: 10,
      currentPage: 1,
      limit: 10,
      total: 10,
      btnLoading: false,
      announcements: [],
      announcement: '',
      listVisible: true,
      noticeListColumns: [
        {
          key: 'title',
          label: 'Title',
          tdClass: 'notice-title-field',
          thClass: 'notice-title-field'
        },
        {
          label: 'Date',
          key: 'create_time',
          formatter: value => {
            return time.utcToLocal(value, 'YYYY-M-D')
          }
        }
      ]
    }
  },
  computed: {
    isContest () {
      return !!this.$route.params.contestID
    },
    rows () {
      return this.announcements.length
    }
  },
  mounted () {
    this.init()
  },
  methods: {
    init () {
      if (this.isContest) {
        this.getContestAnnouncementList()
      } else {
        this.getAnnouncementList()
      }
    },
    getAnnouncementList (page = 1) {
      this.btnLoading = true
      api.getAnnouncementList((page - 1) * this.limit, this.limit).then(res => {
        this.btnLoading = false
        this.announcements = res.data.data.results
        this.total = res.data.data.total
      }, () => {
        this.btnLoading = false
      })
    },
    getContestAnnouncementList () {
      this.btnLoading = true
      api.getContestAnnouncementList(this.$route.params.contestID).then(res => {
        this.btnLoading = false
        this.announcements = res.data.data
      }, () => {
        this.btnLoading = false
      })
    },
    goAnnouncement (announcement) {
      this.announcement = announcement
      this.listVisible = false
      this.$router.push({ name: 'announcement-details', params: { announcementID: announcement.id } })
    }
  }
}
</script>

<style>
  @font-face {
    font-family: Manrope_bold;
    src: url('../../../../fonts/Manrope-Bold.ttf');
  }
  .notice-list-card{
    margin: 0 auto;
    width: 90%;
    font-family: Manrope;
  }
  .top-bar {
    margin-top: 40px;
    margin-left: 68px;
  }
  .title{
    color: #7C7A7B;
  }
  .notice-list-card .table{
    width: 95% !important;
    margin: 0 auto;
  }
  .no-announcement {
    text-align: center;
    font-size: 16px;
    margin: 10px 0;
  }
  .pagination{
    margin-right: 5%;
    margin-top: 20px;
    display: flex;
    justify-content: flex-end;
  }
  .notice-title-field{
    width: 75%;
  }
  .font-bold {
    font-family: manrope_bold;
  }
</style>
