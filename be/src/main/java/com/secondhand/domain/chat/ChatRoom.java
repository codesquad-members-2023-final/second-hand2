package com.secondhand.domain.chat;

import com.secondhand.domain.member.Member;
import com.secondhand.domain.product.Product;
import com.secondhand.util.BaseTimeEntity;
import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import javax.persistence.*;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.stream.Collectors;

@Entity
@Getter
@EntityListeners(AuditingEntityListener.class)
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class ChatRoom extends BaseTimeEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private UUID chatRoomId;

    @Column(nullable = false, length = 1000)
    private String subject;

    @Column(nullable = false)
    private LocalDateTime lastSendTime;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "product_id")
    private Product product;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "customer_id")
    private Member customer;

    //채팅방 하나에 판매자한명 구독하는 사고자하는 사람은 여러명
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(nullable = false, name = "seller_id")
    private Member seller;

    @Enumerated(EnumType.STRING)
    private ChatroomStatus chatroomStatus;

    @Builder
    public ChatRoom(Long id, UUID chatroomId, String subject, Product product, Member customer, Member seller, ChatroomStatus chatroomStatus) {
        this.id = id;
        this.chatRoomId = chatroomId;
        this.subject = subject;
        this.product = product;
        this.customer = customer;
        this.seller = seller;
        this.chatroomStatus = chatroomStatus;
    }

    public static ChatRoom create(Product product, Member buyer) {
        return ChatRoom.builder()
                .chatroomId(UUID.randomUUID())
                .subject("")
                .product(product)
                .customer(buyer)
                .seller(product.getMember())
                .chatroomStatus(ChatroomStatus.FULL)
                .build();
    }

    public void setUserCount(long userCount) {
    }

    public List<String> getChatroomMemberIds() {
        Map<Long, Member> chatroomMembers = getChatroomMembers();
        return chatroomMembers.values().stream()
                .map(Member::getLoginName)
                .collect(Collectors.toList());
    }

    private Map<Long, Member> getChatroomMembers() {
        return Map.of(customer.getId(), customer, this.seller.getId(), this.product.getMember());
    }
}
