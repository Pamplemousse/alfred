FROM ruby:2.4-onbuild

USER 1000:1000

EXPOSE 9292

CMD ["bundle", "exec"]
