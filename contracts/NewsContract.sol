// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract NewsContract {
    // 新闻信息结构体
    struct News {
        // ID
        uint id;
        // 标题
        string title;
        // 内容
        string content;
        // 时间戳
        uint timestamp;
        // 发布者
        address publisher;
    }

    // 新闻及其ID映射
    mapping(uint => News) public newsMap;

    // 总新闻数量
    uint public newsCount;

    // 最新的新闻ID
    uint public latestNewsId;

    // 发布新闻事件
    event NewsPublished(
        uint newsId,
        string title,
        string content,
        uint timestamp,
        address publisher
    );

    // 删除新闻事件
    event NewsDeleted(
        uint newsId
    );

    // 发布新闻
    function publishNews(string memory _title, string memory _content) public {
        newsMap[latestNewsId] = News({
            id: latestNewsId,
            title: _title,
            content: _content,
            timestamp: block.timestamp,
            publisher: msg.sender
        });

        // 最新新闻ID递增
        latestNewsId++;

        // 总新闻数量递增
        newsCount++;

        // 发出NewsPublished事件
        emit NewsPublished(
            latestNewsId,
            _title,
            _content,
            block.timestamp,
            msg.sender
        );
    }

    // 通过新闻ID获取新闻
    function getNewsById(uint _newsId) public view returns (string memory title, string memory content, uint timestamp, address publisher) {
        News memory news = newsMap[_newsId];

        // 返回新闻信息
        return (news.title, news.content, news.timestamp, news.publisher);
    }

    // 通过发布者获取新闻
    function getNewsIdsByPublisher(address _publisher) public view returns (uint[] memory) {
        uint[] memory newsIds = new uint[](latestNewsId);
        uint count = 0;

        // 循环遍历newsMap中的所有新闻
        for (uint i = 1; i <= latestNewsId; i++) {
            // 检查新闻是否由提供的发布者发布
            if (newsMap[i].publisher == _publisher) {
                // 如果新闻由提供的发布者发布，则将其ID添加到newsIds数组中
                newsIds[count] = i;
                count++;
            }
        }

        // 将newsIds数组调整为发布者发布的实际新闻数量
        uint[] memory result = new uint[](count);
        for (uint i = 0; i < count; i++) {
            result[i] = newsIds[i];
        }

        // 返回发布者发布的新闻ID
        return result;
    }

    // 通过ID更新新闻内容
    function updateNewsContent(uint _newsId, string memory _newContent) public {
        // 传引用
        News storage news = newsMap[_newsId];

        // 检查新闻是否存在
        require(news.publisher != address(0), "News does not exist");
        require(msg.sender == news.publisher, "Only the publisher can delete the news");
        news.content = _newContent;

        // 使用更新后的新闻信息发出NewsPublished事件
        emit NewsPublished(_newsId, news.title, news.content, news.timestamp, news.publisher);
    }

    // 通过ID删除新闻
    function deleteNewsById(uint _newsId) public {
        // 传引用
        News storage news = newsMap[_newsId];
        require(news.publisher != address(0), "News does not exist");
        require(msg.sender == news.publisher, "Only the publisher can delete the news");
        delete newsMap[_newsId];
        // 总新闻数量递减
        newsCount--;
        emit NewsDeleted(_newsId);
    }

    // 获取全部新闻
    // 基于演示目的直接全部返回数据，实际应用中不应包含内容部分，应该是返回ID+标题，然后详情页再通过ID获取新闻内容和其他数据
    function getNewsList() public view returns (News[] memory) {
        News[] memory newsList = new News[](newsCount);
        for (uint i = 0; i < newsCount; i++) {
            newsList[i] = newsMap[newsCount - i - 1];
        }
        return newsList;
    }
}