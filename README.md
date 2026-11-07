# 饼干 · 公式卡片

一个可以装到手机桌面的学习 App。FSRS 间隔重复、公式卡片、错题本、统计报表，数据本地存一份、云端存一份。

---

## 一、先搭云端（10 分钟）

### 1. 注册 Supabase

打开 https://supabase.com ，用 GitHub 或邮箱注册，**New project**：

- Name：随便填，比如 `binggan`
- Database Password：随便设一个，记下来
- Region：选 **Southeast Asia (Singapore)**，国内延迟相对低
- 等 1~2 分钟初始化完成

### 2. 建表

左侧菜单 **SQL Editor** → New query，把 `supabase.sql` 整个文件粘进去 → **Run**。

看到 `Success. No rows returned` 就对了。

### 3. 拿两个值

左侧 **Project Settings → API**，复制这两个：

| 名称 | 在哪 | 长什么样 |
|---|---|---|
| Project URL | Project URL | `https://abcdefgh.supabase.co` |
| anon public | Project API keys → anon / public | `eyJhbGciOiJIUzI1NiIs...` |

> anon key 是公开密钥，放在前端是正常做法，配合上面的 RLS 策略使用。**不要**用 `service_role` 那个。

---

## 二、部署网页（5 分钟）

PWA 必须跑在 **https** 下，所以不能双击打开，得放到一个网址上。三个都免费：

### 方式 A：Netlify Drop（最快，拖拽即可）

1. 打开 https://app.netlify.com/drop
2. 把整个文件夹拖进去
3. 几秒后给你一个 `https://xxx.netlify.app` 网址

缺点是国内访问偶尔慢。

### 方式 B：Vercel

1. https://vercel.com 注册
2. New Project → 上传这个文件夹（或连 GitHub）
3. 得到 `https://xxx.vercel.app`

### 方式 C：腾讯云 / 阿里云 静态托管（国内最快）

- 腾讯云 **CloudBase 静态网站托管** 或 **COS + CDN**
- 阿里云 **OSS 静态网站**
- 需要实名 + 绑定域名（可选）

图省事建议先用 A 或 B，跑通了再换。

---

## 三、手机安装

1. 手机浏览器打开你拿到的网址
2. **iOS Safari**：点底部「分享」→「添加到主屏幕」
3. **Android Chrome**：右上角菜单 →「添加到主屏幕」/「安装应用」
4. 桌面会出现那只粉色小恐龙，点开是全屏的，没有地址栏

---

## 四、接上云端

打开 App → 底部「设置」→「云端同步」→ 填三项：

- **Project URL**：`https://xxxx.supabase.co`
- **anon key**：`eyJhbGciOi...`
- **同步码**：自己定，比如 `binggan-7f3a9c2e`（越乱越好，等于密码）

保存后：

- 点「立即上传」，把这台设备的数据推上去
- 换手机时，同样填这三项，点「从云端恢复」
- 打开「自动同步」，之后每次学习完 20 秒会自动静默上传

### 同步逻辑说明

- **本地优先**：所有操作先写 localStorage，断网照常用
- **整包覆盖**：云上只存一份完整数据，最后一次上传的为准
- **不会自动合并**：两台设备同时改，后上传的会覆盖先上传的。个人自用够了，但别在两边同时刷

---

## 五、文件说明

```
index.html      整个应用（约 240KB，含图标和全部逻辑）
sw.js           Service Worker，负责离线缓存
manifest.json   PWA 配置
icon-192.png    桌面图标
icon-512.png    高清图标
supabase.sql    建表语句
README.md       本文件
```

改代码只需要改 `index.html`，改完重新上传覆盖即可。**改了之后记得把 `sw.js` 里的 `CACHE = 'binggan-v1'` 改成 `v2`**，否则手机会一直用旧缓存。

---

## 六、常见问题

**Q：打开还是白屏 / 显示旧版本？**
强制刷新（手机上：设置里清一下该站点数据），或者改 `sw.js` 的缓存版本号。

**Q：上传报 HTTP 401 / 403？**
anon key 填错了，或者 SQL 里的 RLS 策略没跑成功。回 Supabase 的 Table Editor 看看 `binggan_data` 表在不在。

**Q：上传报 404？**
URL 填错了，注意不要带 `/rest/v1` 后缀，只填到 `.supabase.co`。

**Q：两台设备数据打架怎么办？**
先只在一台设备上开自动同步。换设备前手动「立即上传」一次，新设备「从云端恢复」，然后关掉旧设备的自动同步。

**Q：数据存在哪？安全吗？**
本地在浏览器 localStorage（清缓存会没），云端在 Supabase 的 Postgres。建议每周「导出完整备份」存一份到网盘。

**Q：能不能不注册 Supabase？**
可以。设置里「导出完整备份」，换设备时「从备份恢复」，纯手动。云端只是省事。
