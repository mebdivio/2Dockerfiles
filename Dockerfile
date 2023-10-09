# <WARNING>
# Everything within sections like <TAG> is generated and can
# be automatically replaced on deployment. You can disable
# this functionality by simply removing the wrapping tags.
# </WARNING>

# <DOCKER_FROM>
FROM divio/base:1.2-py3.11-slim-bookworm
# </DOCKER_FROM>

# <NPM>
RUN curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor -o /usr/share/keyrings/yarn-archive-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/yarn-archive-keyring.gpg] https://dl.yarnpkg.com/debian stable main" > /etc/apt/sources.list.d/yarn.list && \
    apt-get update && \
    apt-get install -y yarn
# </NPM>

# <BOWER>
# </BOWER>

# <PYTHON>
ENV PIP_INDEX_URL=${PIP_INDEX_URL:-https://wheels.aldryn.net/v1/aldryn-extras+pypi/${WHEELS_PLATFORM:-aldryn-baseproject-py3}/+simple/} \
    WHEELSPROXY_URL=${WHEELSPROXY_URL:-https://wheels.aldryn.net/v1/aldryn-extras+pypi/${WHEELS_PLATFORM:-aldryn-baseproject-py3}/}
COPY requirements.* /app/
COPY addons-dev /app/addons-dev/
RUN pip-reqs compile && \
    pip-reqs resolve && \
    pip install \
        --no-index --no-deps \
        --requirement requirements.urls
# </PYTHON>

# Install NPM packages
RUN npm install

# <SOURCE>
COPY . /app
# </SOURCE>

# <GULP>
RUN yarn build dev
# </GULP>

# <STATIC>
RUN DJANGO_MODE=build python manage.py collectstatic --noinput
# </STATIC>
