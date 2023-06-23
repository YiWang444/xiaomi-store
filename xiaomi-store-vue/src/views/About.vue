<template>
  <div>
    <!-- 显示数据内容 -->
    <ul>
      <li v-for="item in dataList" :key="item.id">{{ item.name }}</li>
    </ul>
    <!-- 加载更多按钮 -->
    <button @click="loadMoreData" ref="loadMoreBtn">加载更多</button>
  </div>
</template>

<script>
export default {
  data() {
    return {
      dataList: [], // 数据列表
      isLoading: false, // 是否正在加载数据
      throttleTimer: null, // 节流定时器
      hasMoreData: true, // 是否还有更多数据
    };
  },
  mounted() {
    window.addEventListener('scroll', this.handleScroll);
  },
  beforeDestroy() {
    window.removeEventListener('scroll', this.handleScroll);
  },
  methods: {
    handleScroll() {
      // 判断是否到达底部
      const scrollTop = window.pageYOffset || document.documentElement.scrollTop || document.body.scrollTop;
      const clientHeight = document.documentElement.clientHeight || document.body.clientHeight;
      const scrollHeight = document.documentElement.scrollHeight || document.body.scrollHeight;

      console.log(scrollTop, scrollHeight, clientHeight);

      if (scrollTop + clientHeight >= scrollHeight && !this.isLoading) {
        // 开始加载更多数据
        this.throttleLoadMoreData();
      }
    },
    throttleLoadMoreData() {
      // 节流函数，限制执行频率
      if (this.throttleTimer) {
        return;
      }
      this.throttleTimer = setTimeout(() => {
        this.loadMoreData();
        clearTimeout(this.throttleTimer);
        this.throttleTimer = null;
      }, 3000); // 500毫秒为节流的间隔时间，可以根据实际情况调整
    },
    loadMoreData() {
      // 加载更多数据的逻辑
      if (this.isLoading || !this.hasMoreData) {
        return;
      }
      this.isLoading = true;
      // 模拟异步请求获取数据
      setTimeout(() => {
        const newDataList = []; // 新加载的数据
        // 将新数据追加到原有数据列表中
        this.dataList = this.dataList.concat(newDataList);
        this.isLoading = false;
        // 判断是否还可以继续加载更多数据，如果不需要加载更多时，隐藏加载更多按钮
        if (!this.hasMoreData) {
          this.$refs.loadMoreBtn.style.display = 'none';
        }
      }, 3000); // 假设异步请求的时间为1秒
    },
  },
};
</script>
