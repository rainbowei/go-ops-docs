FROM swr.cn-north-4.myhuaweicloud.com/glzh-library/nginx:1.18

COPY nginx/default.conf /etc/nginx/conf.d/default.conf

COPY . /var/www/html
